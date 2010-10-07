package com.udox.mp3player.events
{
	import flash.events.Event;
	
	public class VolumeEvent extends Event
	{
		public static var VOLUME:String = 'UdoxVolumeEvent';
		
		private var _volume:Number;
		public function get volumePercent():Number { return _volume; }
		
		public function VolumeEvent(volumePercent:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(VOLUME, bubbles, cancelable);
			_volume = volumePercent;
		}
	}
}