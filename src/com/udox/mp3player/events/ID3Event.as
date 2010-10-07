package com.udox.mp3player.events
{
	import flash.events.Event;
	import flash.media.ID3Info;
	
	public class ID3Event extends Event
	{
		public static var ID3EVENT:String = 'UdoxID3Event';
		
		private var _id3:ID3Info;
		public function get id3info():ID3Info { return _id3; }
		
		public function ID3Event(id3:ID3Info, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(ID3EVENT, bubbles, cancelable);
			_id3 = id3;
		}
	}
}