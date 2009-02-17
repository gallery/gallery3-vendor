package com.gallery.uploader
{
	import flash.net.FileReference;
	
	public class UploadInfo
	{

		public static const PENDNG:String = "pending";
		public static const IN_PROGRESS:String = "inProgress";
		public static const COMPLETED:String = "completed";

		public var size:String;
		public var name:String;
		public var file:FileReference;
		public var status:String;
		
		public function UploadInfo(name:String, size:String, file:FileReference, status:String):void{
			this.name = name;
			this.size = size;
			this.file = file;
			this.status = status;
		}

	}
}