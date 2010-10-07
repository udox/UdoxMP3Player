package com.udox.mp3player.model
{
	import com.udox.mp3player.model.xspf;
	
	public class Track
	{
		use namespace xspf;
		
		public var location:String;		// URI
		// identifier: unique URI
		public var title:String;
		public var creator:String;
		public var annotation:String;	// not HTML
		public var info:String;			// URI (eg buy track)
		public var image:String;		// URI
		public var album:String;
		public var artist:String;		// not in xspf spec
		public var trackNum:Number;		// http://www.w3.org/TR/xmlschema-2/#dt-nonNegativeInteger
		public var duration:Number;		// http://www.w3.org/TR/xmlschema-2/#dt-nonNegativeInteger
		// public var link:String;
		// meta
		// extension
		
		public function Track()
		{
		}
		
		public function loadFields(fields:Object, overwrite:Boolean=false):void
		{
			loadField('album', fields, overwrite);
			loadField('annotation', fields, overwrite);
			loadField('artist', fields, overwrite);
			loadField('creator', fields, overwrite);
			loadField('image', fields, overwrite);
			loadField('info', fields, overwrite);
			loadField('location', fields, overwrite);
			loadField('duration', fields, overwrite);
			loadField('title', fields, overwrite);
			loadField('trackNum', fields, overwrite);
		}
		
		public function loadField(name:String, src:Object, overwrite:Boolean):void
		{
			if (this.hasOwnProperty(name) && (overwrite || isNaN(this[name]) || this[name] === null)) {
				this[name] = src[name].toString();
			}
		}
	}
}