package com.udox.mp3player.events
{
	import com.udox.mp3player.model.Playlist;
	
	import flash.events.Event;
	
	public class PlaylistData extends Event
	{
		public static var PLAYLIST:String = 'PlaylistLoaded';
		
		private var _playlist:Playlist;
		public function get playlist():Playlist { return _playlist; }
		
		public function PlaylistData(playlist:Playlist, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(PLAYLIST, bubbles, cancelable);
			_playlist = playlist;
		}
	}
}