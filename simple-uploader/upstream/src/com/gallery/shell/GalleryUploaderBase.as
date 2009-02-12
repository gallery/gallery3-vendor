// Copyright (C) 2008 Eric Zelermyer
package com.gallery.shell {

	import com.gallery.uploader.Uploader;

	import mx.core.Application;
	import mx.events.FlexEvent;

	public class GalleryUploaderBase extends Application {

		public function GalleryUploaderBase() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		private function onCreationComplete(event:FlexEvent):void {
			// creating uploader here because parameters passed in through html aren't available until creation complete
			var uploader:Uploader = new Uploader();
			// these are the parameters that are specified in flashVars attribute in html
			uploader.settings = Application.application.parameters;

			uploader.percentWidth = 100;
			uploader.percentHeight = 100;

			addChild(uploader);
		}

	}
}
