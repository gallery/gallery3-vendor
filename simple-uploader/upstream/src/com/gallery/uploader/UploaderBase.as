// Copyright (C) 2008 Eric Zelermyer
package com.gallery.uploader {

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;

	public class UploaderBase extends VBox {

		[Bindable]
		// this holds localized strings plus the upload url
		public var settings:Object;

		public var addBtn:Button;
		public var fileGrid:DataGrid;
		public var progressColumn:DataGridColumn;

		private var fileRefList:FileReferenceList;
		private var fileList:ArrayCollection;
		private var currentNum:int = 0;
		private var currentUpload:FileReference;

		public function UploaderBase() {
			super();
			fileList = new ArrayCollection();
		}

		override protected function childrenCreated():void {
			super.childrenCreated();
			addBtn.addEventListener(MouseEvent.CLICK, onAddClick);
			fileGrid.addEventListener(ProgressRendererBase.CANCEL_UPLOAD, onCancelUpload);

			// setup renderer for column with progress bar
			// doing this dynamically so that we can pass in localized strings from html
			var renderer:ClassFactory = new ClassFactory(ProgressRenderer);
			renderer.properties = {completeText:settings.completeText, pendingText:settings.pendingText};
			progressColumn.itemRenderer = renderer;

			fileGrid.dataProvider = fileList;
		}

		private function onAddClick(event:MouseEvent):void {
			var imageTypes:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.jpeg; *.gif; *.png");
			fileRefList = new FileReferenceList();
			fileRefList.addEventListener(Event.SELECT, onSelectFiles);
			fileRefList.browse([imageTypes]);
		}

		private function onSelectFiles(event:Event):void {
			if (fileRefList.fileList.length >= 1) {
				for(var i:int = 0; i < fileRefList.fileList.length; i++) {
					fileList.addItem({name:fileRefList.fileList[i].name, size:formatFileSize(fileRefList.fileList[i].size), file:fileRefList.fileList[i]});
				}

				if (!currentUpload) {
					uploadFile(fileList.getItemAt(currentNum));
				}
			}
		}

		private function formatFileSize(numSize:Number):String {
			var strReturn:String;
			numSize = Number(numSize / 1000);
			strReturn = String(numSize.toFixed(1) + " KB");
			if (numSize > 1000) {
				numSize = numSize / 1000;
				strReturn = String(numSize.toFixed(1) + " MB");
				if (numSize > 1000) {
					numSize = numSize / 1000;
					strReturn = String(numSize.toFixed(1) + " GB");
				}
			}
			return strReturn;
		}

		private function uploadFile(fileInfo:Object):void {
			currentUpload = fileInfo.file;

			var sendVars:URLVariables = new URLVariables();
			// parameters to pass to upload script should go here
			//sendVars.parameter = "value";

			var request:URLRequest = new URLRequest();
			request.data = sendVars;
			request.url = settings.uploadUrl;
			request.method = URLRequestMethod.POST;
			currentUpload.addEventListener(Event.COMPLETE, onUploadComplete);
			currentUpload.addEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
			currentUpload.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
			currentUpload.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			currentUpload.upload(request, "file", false);
		}

		private function onUploadComplete(event:Event):void {
			clearListeners();
			currentNum++;
			startNextUpload();
		}

		private function startNextUpload():void {
			if (currentNum < fileList.length) {
				uploadFile(fileList.getItemAt(currentNum));
			} else {
				currentUpload = null;
			}
		}

		private function onCancelUpload(event:Event):void {
			var fileData:Object = (event.target as ProgressRenderer).data;
			var itemIndex:int = fileList.getItemIndex(fileData);

			fileList.removeItemAt(itemIndex);

			if (itemIndex == currentNum) {
				if (currentUpload) {
					clearListeners();
					currentUpload.cancel();
				}
				startNextUpload();
			} else if (itemIndex < currentNum) {
				currentNum--;
			}
		}

		private function clearListeners():void {
			currentUpload.removeEventListener(Event.COMPLETE, onUploadComplete);
			currentUpload.removeEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
			currentUpload.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
			currentUpload.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
		}

		private function onUploadIoError(event:IOErrorEvent):void {
			handleError(event.text);
		}

		private function onUploadSecurityError(event:SecurityErrorEvent):void {
			handleError(event.text);
		}

		private function onHttpStatus(event:HTTPStatusEvent):void {
			handleError("HTTP error " + event.status);
		}

		private function handleError(text:String):void {
			clearListeners();
			Alert.show(text, "Error");
		}

	}
}
