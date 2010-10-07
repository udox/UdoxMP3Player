package com.udox.mp3player.model
{
	import com.udox.mp3player.model.xspf;
	import com.udox.utils.StringTemplate;

	public class Playlist
	{
		use namespace xspf;
		
		public var title:String;
		public var creator:String;
		public var annotation:String;	// not HTML
		public var info:String;			// URI
		public var location:String;		// URI
		public var identifier:String;	// URI (unique)
		public var image:String;		// URI
		public var date:String;			// http://www.w3.org/TR/xmlschema-2/#dateTime
		/**
		 * in XSPF spec but omitted here:
		 * - license
		 * - attribution
		 * - link
		 * - meta
		 * - extension
		 */
		
		public var tracks:Array; // of Track objects
		
		public function Playlist()
		{
			tracks = [];
		}
		
		public function getTracks(template:String='%(location)s'):Array
		{
			var urls:Array = []
			for each(var t:Track in tracks) {
				urls.push(StringTemplate.parse(template, t));
			}
			return urls;
		}
		
		public function loadFields(fields:Object, overwrite:Boolean=false):void
		{
			loadField('title', fields, overwrite);
			loadField('creator', fields, overwrite);
			loadField('annotation', fields, overwrite);
			loadField('info', fields, overwrite);
			loadField('location', fields, overwrite);
			loadField('identifier', fields, overwrite);
			loadField('image', fields, overwrite);
			loadField('date', fields, overwrite);
		}
		
		public function loadField(name:String, src:Object, overwrite:Boolean):void
		{
			if (this.hasOwnProperty(name) && (overwrite || isNaN(this[name]) || this[name] === null)) {
				this[name] = src[name].toString();
			}
		}
	}
}