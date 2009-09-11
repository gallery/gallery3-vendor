/*
 * jQuery UI Selectable @VERSION
 *
 * Copyright (c) 2009 AUTHORS.txt (http://ui.jquery.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Selectables
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

	$.widget('ui.selectable', $.extend({}, $.ui.mouse, {

		_init: function() {

			var self = this;
			this.items = $(this.options.filter, this.element);
			this.element.addClass("ui-selectable ui-widget");

			//Set the currentFocus to the first item
			this.currentFocus = this.items.eq(0).attr('tabindex', 0);

			//Refresh item positions
			this.refresh(1);

			//Disable text selection
			this.element.disableSelection();

			//Prepare caret selection
			if(this.options.lasso) {

				// we need to move the lasso options onto the root options for the mouse clas
				if(this.options.lasso !== true) {
					$.extend(this.options, this.options.lasso);
				}

				this._mouseInit();
			}

			this.element
				.bind('mousedown.selectable', function(event) {

					if(self.options.disabled)
						return;

					var item = self._targetIsItem(event.target);
					if (!item) return;

					// If item is part of current selection and current
				    // selection is multiple, return and allow mouseup
				    // to fire (Windows gets this right too, OSX doesn't)
				    if(self._selection.length > 1 && $(item).hasClass('ui-selected')) {
				    	return (self._listenForMouseUp = 1);
				    }

					if(self._trigger('beforeselect', event) === false)
						return true;

					self._select(event, item);
					self.element[0].focus();
					event.preventDefault();

				})
				.bind('mouseup.selectable', function(event) {
					if(self._listenForMouseUp) {

						self._listenForMouseUp = 0;
						var item = self._targetIsItem(event.target);
						if (!item) return;

						if(self._trigger('beforeselect', event) === false)
							return true;

						self._select(event, item);
						self.element[0].focus();
						event.preventDefault();
					}
				})
				.bind('focus.selectable', function() {
					if(!self.options.disabled) self.currentFocus.addClass('ui-state-focus');
				})
				.bind('blur.selectable', function() {
					if(!self.options.disabled) self.currentFocus.removeClass('ui-state-focus');
				})
				.bind('keydown.selectable', function(event) {

					if(!self.options.keyboard || self.options.disabled)
						return;

					if(self._trigger('beforeselect', event) === false)
						return true;

					if(event.keyCode == $.ui.keyCode.DOWN) {
						self.options.closest ? self.selectClosest('down', event) : self.next(event);
						event.preventDefault();
					}

					if(event.keyCode == $.ui.keyCode.RIGHT) {
						self.options.closest ? self.selectClosest('right', event) : self.next(event);
						event.preventDefault();
					}

					if(event.keyCode == $.ui.keyCode.UP) {
						self.options.closest ? self.selectClosest('up', event) : self.previous(event);
						event.preventDefault();
					}

					if(event.keyCode == $.ui.keyCode.LEFT) {
						self.options.closest ? self.selectClosest('left', event) : self.previous(event);
						event.preventDefault();
					}

					if ((event.ctrlKey || event.metaKey) && event.keyCode == $.ui.keyCode.SPACE) {
						self._toggleSelection(self.currentFocus, event);
					}

				});

			this.helper = $(document.createElement('div'))
				.addClass("ui-selectable-lasso");

		},

		selectClosest: function(direction, event) {

			var current = [/(down|right)/.test(direction) ? 10000 : -10000, null],
				overlap = 10000,
				selfOffset = this.currentFocus.data('selectable-item');

			this.items.not(this.currentFocus).filter(':visible').each(function() {

				var $this = $(this),
					offset = $this.data('selectable-item'),
					distance = {
						x: Math.abs(selfOffset.left - offset.left) + Math.abs((offset.left+this.offsetWidth) - (selfOffset.left+this.offsetWidth)),
						y: Math.abs(selfOffset.top - offset.top) + Math.abs((offset.top+this.offsetHeight) - (selfOffset.top+this.offsetHeight))
					};

				switch(direction) {

					case 'up':
						if((selfOffset.top > offset.top && offset.top >= current[0]) && (offset.top != current[0] || distance.x < overlap)) {
							current = [offset.top, $this];
							overlap = distance.x;
						}
						break;

					case 'down':
						if((selfOffset.top < offset.top && offset.top <= current[0]) && (offset.top != current[0] || distance.x < overlap)) {
							current = [offset.top, $this];
							overlap = distance.x;
						}
						break;

					case 'left':
						if((selfOffset.left > offset.left && offset.left >= current[0]) && (offset.left != current[0] || distance.y < overlap)) {
							current = [offset.left, $this];
							overlap = distance.y;
						}
						break;

					case 'right':
						if((selfOffset.left < offset.left && offset.left <= current[0]) && (offset.left != current[0] || distance.y < overlap)) {
							current = [offset.left, $this];
							overlap = distance.y;
						}
						break;

				}

			});

			// if nothing close is found, bail
			if(!current[1])
				return false;

			//We need to find the index of the current, and the index of the new one to call selectAdjacent
			// - calling _select doesn't work, since it's only for mouse interaction (no ctrl focus move!)
			var currentIndex = this.items.index(this.currentFocus[0]);
			var newIndex = this.items.index(current[1]);

			return this._selectAdjacent(event, newIndex - currentIndex);

		},

		destroy: function() {
			this.items.removeClass("ui-selectable-item ui-selected ui-state-active");
			this.element
				.removeClass("ui-selectable ui-selectable-disabled ui-widget")
				.removeData("selectable")
				.unbind(".selectable");
			this._mouseDestroy();
		},

		_mouseCapture: function(event) {
			//If the item we start dragging on is a selectable, we bail (if keyboard is used)
			this.clickedOnItem = this._targetIsItem(event.target);
			return true; // TODO: this starts the lasso on items as well - we might want to introduce an option to disable this
		},

		_mouseStart: function(event) {

			var self = this, o = this.options;
			this.opos = [event.pageX, event.pageY];

			if (o.disabled)
				return;

			//Cache positions
			this.refresh(1);

			//Trigger start event
			this._trigger("start", event, this._uiHash());

			//Save the current selection as previous
			this._previousSelection = this._selection.slice();

			// append and position helper (lasso)
			$('body').append(this.helper);
			this.helper.css({
				zIndex: 100,
				position: "absolute",
				left: event.clientX,
				top: event.clientY,
				width: 0,
				height: 0
			});

			//Tell the intersection that some start selected
			for (var i = this._selection.length - 1; i >= 0; i--){
				if(event.metaKey || event.ctrlKey) {
					if(this != self.clickedOnItem) $(this._selection[i]).data("selectable-item").startSelected = true;
				} else self._removeFromSelection($(this._selection[i]), event);
			};

		},

		_mouseDrag: function(event) {

			var self = this, o = this.options;

			if (o.disabled)
				return;

			//Do the lasso magic
			var x1 = this.opos[0], y1 = this.opos[1], x2 = event.pageX, y2 = event.pageY;
			if (x1 > x2) { var tmp = x2; x2 = x1; x1 = tmp; }
			if (y1 > y2) { var tmp = y2; y2 = y1; y1 = tmp; }
			this.helper.css({left: x1, top: y1, width: x2-x1, height: y2-y1});

			//Loop through all items and check overlaps
			this.items.each(function() {

				var item = $.data(this, "selectable-item");

				//prevent helper from being selected if appendTo: selectable
				if (!item || item.element == self.element[0])
					return;

				var hit = false;
				if (o.lasso && o.lasso.tolerance == 'touch') {
					hit = ( !(item.left > x2 || item.right < x1 || item.top > y2 || item.bottom < y1) );
				} else if (o.lasso && o.lasso.tolerance == 'fit') {
					hit = (item.left > x1 && item.right < x2 && item.top > y1 && item.bottom < y2);
				}

				hit ?
					item.startSelected ? self._removeFromSelection($(this), event) : self._addToSelection($(this), event)
				:  !item.startSelected ? self._removeFromSelection($(this), event) : self._addToSelection($(this), event);

			});

			return false;

		},

		_mouseStop: function(event) {

			var newlySelected = [],
				newlyDeselected = [];

			// Find out the delta of the newly selected items
			for (var i=0; i < this._selection.length; i++) {
				var wasAlreadyPartOfPreviousSelection = false;
				for (var j=0; j < this._previousSelection.length; j++) {
					if(this._selection[i][0] == this._previousSelection[j][0])
						wasAlreadyPartOfPreviousSelection = true;
				};
				if(!wasAlreadyPartOfPreviousSelection) newlySelected.push(this._selection[i]);
			};

			// Find out the delta of the newly unselected items
			for (var i = this._previousSelection.length - 1; i >= 0; i--){
				if(!this._previousSelection[i].data('selectable-item').selected) newlyDeselected.push(this._previousSelection[i]);
			};


			// Transform both deltas into jQuery objects
			newlySelected = $($.map(newlySelected, function(i) { return i[0]; }));
			newlyDeselected = $($.map(newlyDeselected, function(i) { return i[0]; }));

			var uiHash = $.extend(this._uiHash(), {
				added: newlySelected || [],
				removed: newlyDeselected || []
			});
			this._trigger("stop", event, uiHash);

			// Trigger change event if anything has changed
			if((newlySelected && newlySelected.length) || (newlyDeselected && newlyDeselected.length)) {
				this._trigger('change', event, uiHash);
			}

			this.helper.remove();
			return false;
		},

		_targetIsItem: function(item) {
			var found = $(item).parents().andSelf().filter(':data(selectable-item)');
			return found.length && found;
		},

		_selection: [],

		_endSelection: function(event, newlySelected) {

			//Only trigger the 'deselect' event if items have been removed from the selection
			var newlyDeselected = this._triggerDeselection(event);

			//Only trigger 'select' event if items have been added to the selection
			if(newlySelected && newlySelected.length)
				this._trigger('select', event, this._uiHash(newlySelected, 'added'));

			// Trigger change event if anything has changed
			if((newlySelected && newlySelected.length) || (newlyDeselected && newlyDeselected.length)) {
				var uiHash = $.extend(this._uiHash(), {
					added: newlySelected || [],
					removed: newlyDeselected || []
				});
				this._trigger('change', event, uiHash);
			}

		},

		_triggerDeselection: function(event) {

			var triggerItems = [];

			for (var i = this._previousSelection.length - 1; i >= 0; i--){
				var data = this._previousSelection[i].data('selectable-item');
				if(!data || !data.selected) triggerItems.push(this._previousSelection[i]);
			};

			this._previousSelection = [];
			triggerItems = $($.map(triggerItems, function(i) { return i[0]; }));
			if(triggerItems.length) this._trigger('deselect', event, this._uiHash(triggerItems, 'removed'));

			return triggerItems;

		},

		_clearSelection: function(triggerEvent) {

			var triggerItems = [];

			for (var i = this._selection.length - 1; i >= 0; i--){
                          var data = this._selection[i].data('selectable-item');
			  if(triggerEvent && data && data.selected) triggerItems.push(this._selection[i]);
				this._selection[i].removeClass('ui-selected ui-state-active');
                          if (data)
				data.selected = false;
			};

			this._previousSelection = this._selection.slice();
			this._selection = [];
			if(triggerEvent && triggerItems.length) this._trigger('deselect', triggerEvent, this._uiHash($($.map(triggerItems, function(i) { return i[0]; })), 'removed'));

		},

		_toggleSelection: function(item, event) {
			var selected = item.data('selectable-item').selected;
			selected ? this._removeFromSelection(item, event) : this._addToSelection(item);
			return !selected;
		},

		_addToSelection: function(item, triggerEvent) {

			if (item.data('selectable-item').selected)
				return null;

			this._selection.push(item);
			this.latestSelection = item;
			item.addClass('ui-selected ui-state-active');
			item.data('selectable-item').selected = true;

			if(triggerEvent) {
				this._trigger('select', triggerEvent, $.extend({ lasso: true }, this._uiHash(item)));
			}

			return item;

		},

		_removeFromSelection: function(item, triggerEvent) {

			for (var i=0; i < this._selection.length; i++) {
				if (this._selection[i][0] == item[0]) {
					this._selection[i].removeClass('ui-selected ui-state-active');
                                        var data = this._selection[i].data('selectable-item');
                                        if (data) {
                                            data.selected = false;
                                        }

					this._selection.splice(i,1);
					if(triggerEvent) this._trigger('deselect', triggerEvent, this._uiHash($(item), 'removed'));
					break;
				}
			};

		},

		_updateSelectionMouse: function(event) {

			var newlySelected = [];

			if (event && event.shiftKey) {

				//Clear the previous selection to make room for a shift selection
				this._clearSelection();

				var index = this.items.index(this.latestWithoutModifier[0]) > this.items.index(this.currentFocus[0]) ? -1 : 1;
				var i = this.latestWithoutModifier.data('selectable-item').selected ? this.items.eq(this.items.index(this.latestWithoutModifier[0])+index) : this.latestWithoutModifier;
				while(i.length && i[0] != this.currentFocus[0]) {
					i[0] == this.previousFocus[0] ? this._addToSelection(i) : newlySelected.push(this._addToSelection(i));
					i = this.items.eq(this.items.index(i[0])+index);
				}

				//Readd the item with the current focus
				newlySelected.push(this._addToSelection(this.currentFocus));

			} else {

				if (event && (event.metaKey || event.ctrlKey)) {
					var withMetaIsNewlySelected = this._toggleSelection(this.currentFocus, event);
					if(withMetaIsNewlySelected) newlySelected.push(this.currentFocus);
				} else {
					this._clearSelection();
					newlySelected.push(this._addToSelection(this.currentFocus));
					this.latestWithoutModifier = this.currentFocus;
				}

			}

			return $($.map(newlySelected, function(i) { return i[0]; }));

		},

		_updateSelection: function(event, index) {

			var newlySelected = [];

			if (event && event.shiftKey) {

				if (this.currentFocus.data('selectable-item').selected) {
					this._removeFromSelection(this.previousFocus, event);
				} else {

					var index2 = this.items.index(this.latestSelection[0]) > this.items.index(this.currentFocus[0]) ? 1 : -1;
					if (!this.previousFocus.data('selectable-item').selected) {
						var i = index == index2 ? this.items.eq(this.items.index(this.previousFocus[0])+index2) : this.previousFocus;
						while(i.length && !i.data('selectable-item').selected) {
							newlySelected.push(this._addToSelection(i));
							i = this.items.eq(this.items.index(i[0])+index2);
						}
					}

					newlySelected.push(this._addToSelection(this.currentFocus));

				}

			} else {

				//If the CTRL or Apple/Win key is pressed, only set focus
				if (event && (event.metaKey || event.ctrlKey))
					return;

				this._clearSelection(event);
				newlySelected.push(this._addToSelection(this.currentFocus));
				this.latestWithoutModifier = this.currentFocus;

			}

			return $($.map(newlySelected, function(i) { if(i) return i[0]; }));

		},

		_select: function(event, item) {

			//Set the current selection to the previous/next item
			this.previousFocus = this.currentFocus.attr('tabindex', -1);
			this.currentFocus = $(item).attr('tabindex', 0);

			this.previousFocus.removeClass('ui-state-focus');
			this.currentFocus.addClass('ui-state-focus');

			//Set and update the selection
			var newlySelected = this._updateSelectionMouse(event);

			// Ending the selection does a diff and then triggers appropriate events
			this._endSelection(event, newlySelected);

		},

		_selectAdjacent: function(event, index) {

			var item = this.items.eq(this.items.index(this.currentFocus[0]) + index);

			//Bail if there's no previous/next item
			if (!item.length) return;

			//Set the current selection to the previous/next item
			this.previousFocus = this.currentFocus.attr('tabindex', -1);
			this.currentFocus = item.attr('tabindex', 0);

			this.previousFocus.removeClass('ui-state-focus');
			this.currentFocus.addClass('ui-state-focus');

			//Set and update the selection
			this._previousSelection = this._selection.slice();
			var newlySelected = this._updateSelection(event, index);

			// Ending the selection does a diff and then triggers appropriate events
			this._endSelection(event, newlySelected);

		},

		previous: function(event) {
			this._selectAdjacent(event, -1);
		},

		next: function(event) {
			this._selectAdjacent(event, 1);
		},

		refresh: function(fromInside) {

			var o = this.options, self = this;
			this.items = $(o.filter, this.element);
			this.items.addClass('ui-selectable-item');
			this.items.each(function() {

				var $this = $(this);
				var pos = $this.offset();

				if(self.currentFocus && self.currentFocus[0] != this)
					$this.attr('tabindex', -1);

				$.data(this, "selectable-item", {
					left: pos.left,
					top: pos.top,
					right: pos.left + $this.width(),
					bottom: pos.top + $this.height(),
					startSelected: false,
					selected: $this.hasClass('ui-selected')
				});
			});


			if(!fromInside) {
				this._previousSelection = this._selection.slice();
				this._selection = [];
				for (var i=0; i < this._previousSelection.length; i++) {
					if(this._previousSelection[i][0].parentNode) this._selection.push(this._previousSelection[i]);
				};

				this._endSelection();
			}


		},

		select: function(item) {

			if(!isNaN(parseInt(item)))
				item = this.items.get(item);

			item = $(item, this.element);
			if(!item.length) return;

			// clear the current selection
			this._clearSelection();

			// select all found
			var newlySelected = [], self = this;
			item.each(function(i) {
				if(i == 0) { //Setting the focus on the first item in the list
					self.previousFocus = self.currentFocus.attr('tabindex', -1);
					self.currentFocus = $(this).attr('tabindex', 0);
					self.previousFocus.removeClass('ui-state-focus');
					self.currentFocus.addClass('ui-state-focus');
				}
				newlySelected.push(self._addToSelection($(this)));
			});

			// Ending the selection does a diff and then triggers appropriate events
			this._endSelection(event, $($.map(newlySelected, function(i) { return i[0]; })));

		},

		deselect: function(item) {

			// if no item was specified, deselect all
			if(!item)
				this._clearSelection(true);

			if(!isNaN(parseInt(item)))
				item = this.items.get(item);

			item = $(item, this.element);
			if(!item.length) return;

			//store the current selection
			this._previousSelection = this._selection.slice();

			// deselect all found
			var self = this;
			item.each(function() {
				self._removeFromSelection($(this));
			});

			// Ending the selection does a diff and then triggers appropriate events
			this._endSelection(event);

		},

		_uiHash: function(items, specialKey) {
			var uiHash =  {
				previousFocus: this.previousFocus,
				currentFocus: this.currentFocus,
				selection: $($.map(this._selection, function(i) { return i[0]; }))
			};
			if(specialKey) uiHash[specialKey] = items;
			return uiHash;
		}

	}));

	$.extend($.ui.selectable, {
		defaults: {
			closest: true,
			filter: '> *',

			keyboard: true,
			lasso: {
				cancel: ":input,option",
				delay: 0,
				distance: 1,
				tolerance: 'touch',
				appendTo: 'body'
			}
		}
	});

})(jQuery);
