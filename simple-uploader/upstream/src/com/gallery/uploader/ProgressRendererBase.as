// Copyright (C) 2008 Eric Zelermyer
package com.gallery.uploader {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;

	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarMode;

	public class ProgressRendererBase extends HBox {

		public static const CANCEL_UPLOAD:String = "cancelUpload";

		public var completeText:String;
		public var pendingText:String;

		public var progress:ProgressBar;
		public var cancelBtn:Button;

		private var dataChanged:Boolean;
		private var file:FileReference;

		public function ProgressRendererBase() {
			super();
		}

		override protected function childrenCreated():void {
			super.childrenCreated();
			cancelBtn.addEventListener(MouseEvent.CLICK, onCancelClick);
			progress.label = pendingText;
		}

		private function onCancelClick(event:MouseEvent):void {
			dispatchEvent(new Event(CANCEL_UPLOAD, true));
		}

		private function onProgress(event:ProgressEvent):void {
			file.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			// loading has started, so start showing percentage
			progress.label = "%3%";
		}

		private function onUploadComplete(event:Event):void {
			file.removeEventListener(Event.COMPLETE, onUploadComplete);
			file.removeEventListener(ProgressEvent.PROGRESS, onProgress);

			// force progress bar to 100%, sometimes it wasn't doing this automatically
			progress.mode = ProgressBarMode.MANUAL;
			progress.setProgress(1, 1);
			progress.label = completeText;
		}

		override public function set data(value:Object):void {
			super.data = value;
			if (value.file) {
				dataChanged = true;
				file = value.file as FileReference;
				file.addEventListener(ProgressEvent.PROGRESS, onProgress);
				file.addEventListener(Event.COMPLETE, onUploadComplete);
				invalidateProperties();
			}
		}

		override protected function commitProperties():void {
			super.commitProperties();
			if (dataChanged) {
				var fileRef:FileReference = data.file as FileReference;
				// this tells progress bar to listen for progress events from file reference
				progress.source = fileRef;
				dataChanged = false;
			}
		}

	}
}
