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
			this.element.addClass("ui-selectable");

			//Set the currentFocus to the first item
			this.currentFocus = this.items.eq(0);
			
			//Refresh item positions
			this.refresh();

			//Disable text selection
			this.element.disableSelection();

			//Prepare caret selection
			if(this.options.lasso) this._mouseInit();

			this.element
				.bind('mousedown.selectable', function(event) {

					var item = self._targetIsItem(event.target);
					if (!item) return;
					
					// If item is part of current selection and current
				    // selection is multiple, return and allow mouseup
				    // to fire (Windows gets this right too, OSX doesn't)
				    if(self._selection.length > 1 && $(item).hasClass(self.options.selectedClass)) {
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
					self.currentFocus.addClass('ui-focused');
				})
				.bind('blur.selectable', function() {
					self.currentFocus.removeClass('ui-focused');
				})
				.bind('keydown.selectable', function(event) {

					if(!self.options.keyboard)
						return;
						
					if(self._trigger('beforeselect', event) === false)
						return true;
					
					if(event.keyCode == $.ui.keyCode.DOWN) {
						self.options.smart ? self.selectClosest('down', event) : self.selectNext(event);
						event.preventDefault();
					}
					
					if(event.keyCode == $.ui.keyCode.RIGHT) {
						self.options.smart ? self.selectClosest('right', event) : self.selectNext(event);
						event.preventDefault();
					}
					
					if(event.keyCode == $.ui.keyCode.UP) {
						self.options.smart ? self.selectClosest('up', event) : self.selectPrevious(event);
						event.preventDefault();
					}
					
					if(event.keyCode == $.ui.keyCode.LEFT) {
						self.options.smart ? self.selectClosest('left', event) : self.selectPrevious(event);
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

			$(this.options.filter, this.element).not(this.currentFocus).filter(':visible').each(function() {

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
			
			return current[1] ? this._select(event, current[1]) : false;
			
		},

		destroy: function() {
			this.element
				.removeClass("ui-selectable ui-selectable-disabled")
				.removeData("selectable")
				.unbind(".selectable");
			this._mouseDestroy();
		},
		
		_mouseCapture: function(event) {
			//If the item we start dragging on is a selectable, we bail (if keyboard is used)
			this.clickedOnItem = this._targetIsItem(event.target);
			return !this.options.keyboard || !this.clickedOnItem;
		},
		
		_mouseStart: function(event) {
			
			var self = this, o = this.options;
			this.opos = [event.pageX, event.pageY];
	
			if (o.disabled)
				return;
	
			//Cache positions
			this.refresh();
	
			//Trigger start event
			this._trigger("start", event, this._uiHash());
	
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
			this.items.filter('.'+this.options.selectedClass).each(function() {
				if(event.metaKey) {
					if(this != self.clickedOnItem) $.data(this, "selectable-item").startSelected = true;
				} else self._removeFromSelection($(this), event);
			});
				
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
			this._trigger("stop", event, this._uiHash());
			this.helper.remove();
			return false;
		},	
		
		_targetIsItem: function(item) {
			var found = $(item).parents().andSelf().filter(':data(selectable-item)');
			return found.length && found;
		},		

		_selection: [],

		_clearSelection: function(triggerEvent) {

			var triggerItems = [];

			for (var i = this._selection.length - 1; i >= 0; i--){
				if(triggerEvent && this._selection[i].data('selectable-item').selected) triggerItems.push(this._selection[i]);
				this._selection[i].removeClass(this.options.selectedClass);
				this._selection[i].data('selectable-item').selected = false;
			};

			this._selection = [];
			if(triggerEvent) this._trigger('unselect', triggerEvent, this._uiHash($($.map(triggerItems, function(i) { return i[0]; })), 'removed'));

		},

		_toggleSelection: function(item, event) {
				item.data('selectable-item').selected ? this._removeFromSelection(item, event) : this._addToSelection(item);
		},

		_addToSelection: function(item, triggerEvent) {

			if (item.data('selectable-item').selected)
				return null;

			this._selection.push(item);
			this.latestSelection = item;
			item.addClass(this.options.selectedClass);
			item.data('selectable-item').selected = true;
			
			if(triggerEvent) {
				this._trigger('select', triggerEvent, $.extend({ lasso: true }, this._uiHash(item)));
			}
			
			return item;

		},

		_removeFromSelection: function(item, triggerEvent) {

			for (var i=0; i < this._selection.length; i++) {
				if (this._selection[i][0] == item[0]) {
					this._selection[i].removeClass(this.options.selectedClass);
					this._selection[i].data('selectable-item').selected = false;
					this._selection.splice(i,1);
					if(triggerEvent) this._trigger('unselect', triggerEvent, this._uiHash($(item), 'removed'));
					break;
				}
			};

		},

		_updateSelectionMouse: function(event) {

			var newlySelected = [];

			if (event.shiftKey && this.options.multiple) {

				//Clear the previous selection to make room for a shift selection
				this._clearSelection(event);

				var index = this.items.index(this.latestWithoutModifier[0]) > this.items.index(this.currentFocus[0]) ? -1 : 1;
				var i = this.latestWithoutModifier.data('selectable-item').selected ? this.items.eq(this.items.index(this.latestWithoutModifier[0])+index) : this.latestWithoutModifier;
				while(i.length && i[0] != this.currentFocus[0]) {
					i[0] == this.previousFocus[0] ? this._addToSelection(i) : newlySelected.push(this._addToSelection(i));
					i = this.items.eq(this.items.index(i[0])+index);
				}

				//Readd the item with the current focus
				newlySelected.push(this._addToSelection(this.currentFocus));

			} else {

				if (event.metaKey) {
					this._toggleSelection(this.currentFocus, event);
				} else {
					this._clearSelection(event);
					newlySelected.push(this._addToSelection(this.currentFocus));
					this.latestWithoutModifier = this.currentFocus;
				}

			}
			
			return $($.map(newlySelected, function(i) { return i[0]; }));

		},

		_updateSelection: function(event, index) {

			var newlySelected = [];

			if (event.shiftKey && this.options.multiple) {

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
				if (event.metaKey)
					return;

				this._clearSelection(event);
				newlySelected.push(this._addToSelection(this.currentFocus));
				this.latestWithoutModifier = this.currentFocus;

			}
			
			return $($.map(newlySelected, function(i) { return i[0]; }));

		},

		_select: function(event, item) {

			//Set the current selection to the previous/next item
			this.previousFocus = this.currentFocus;
			this.currentFocus = $(item);

			this.previousFocus.removeClass('ui-focused');
			this.currentFocus.addClass('ui-focused');

			//Set and update the selection
			var newlySelected = this._updateSelectionMouse(event);

			//Trigger select event
			if(newlySelected && newlySelected.length) this._trigger('select', event, this._uiHash(newlySelected, 'added'));

		},

		_selectAdjacent: function(event, index) {

			var item = this.items.eq(this.items.index(this.currentFocus[0]) + index);
		
			//Bail if there's no previous/next item
			if (!item.length) return;

			//Set the current selection to the previous/next item
			this.previousFocus = this.currentFocus;
			this.currentFocus = item;

			this.previousFocus.removeClass('ui-focused');
			this.currentFocus.addClass('ui-focused');

			//Set and update the selection
			var newlySelected = this._updateSelection(event, index);

			//Trigger select event
			if(newlySelected && newlySelected.length) this._trigger('select', event, this._uiHash(newlySelected, 'added'));

		},

		selectPrevious: function(event) {
			this._selectAdjacent(event, -1);
		},

		selectNext: function(event) {
			this._selectAdjacent(event, 1);
		},
		
		refresh: function() {

			var o = this.options;
			this.items = $(o.filter, this.element);
			this.items.each(function() {
				var $this = $(this);
				var pos = $this.offset();
				$.data(this, "selectable-item", {
					left: pos.left,
					top: pos.top,
					right: pos.left + $this.width(),
					bottom: pos.top + $this.height(),
					startSelected: false,
					selected: $this.hasClass(o.selectedClass)
				});
			});

		},
		
		select: function(item) {
			//TODO
		},
		
		deselect: function(item) {
			if(!item) this._clearSelection(true);
			//TODO: Deselect single elements
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

			//TODO: Figure out how to move these defaults out
			cancel: ":input,option",
			delay: 0,
			distance: 1,
			appendTo: 'body',

			multiple: true,
			smart: true,
			filter: '> *',
			
			keyboard: true,
			lasso: {
				cancel: ":input,option",
				delay: 0,
				distance: 1,
				tolerance: 'touch',
				appendTo: 'body'
			},
			
			//Should we really delete that?
			selectedClass: 'ui-state-selected'
		}
	});

})(jQuery);
