package com.udox.mp3player.controller
{
	import com.udox.mp3player.events.PlaylistData;
	import com.udox.mp3player.model.Playlist;
	import com.udox.mp3player.model.Track;
	import com.udox.mp3player.model.xspf;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class PlaylistLoader extends EventDispatcher
	{
		public var xmlLoader:URLLoader;
		public var url:String = '';
		
		use namespace xspf;
		
		public function PlaylistLoader(url:String)
		{
			this.url = url;
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			xmlLoader.addEventListener(Event.COMPLETE, onResult);
			xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			xmlLoader.addEventListener(Event.OPEN, onOpen);
			xmlLoader.addEventListener(Event.ACTIVATE, onActivate);
		}
		
		public function loadData():void {
			var req:URLRequest = new URLRequest(url);
			trace('loadData', req.url);
			xmlLoader.load(req);
		}
		
		protected function onResult(e:Event):void
		{
			var xmlData:XML = new XML(e.target.data);
			parseData(xmlData);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		protected function onOpen(e:Event):void
		{
			trace(e);
		}
		
		protected function onActivate(e:Event):void
		{
			trace(e);
		}
		
		protected function onIOError(e:IOErrorEvent):void
		{
			trace(e);
		}
		
		/**
		 * turns the xspf xml into Playlist/Track models
		 */
		public function parseData(xml:XML):void
		{
			var playlist:Playlist = new Playlist();
			playlist.loadFields(xml);
			
			for each(var t:XML in xml.trackList.track){
				var track:Track = new Track();
				track.loadFields(t);
				playlist.tracks.push(track);
			}
			
			dispatchEvent(new PlaylistData(playlist));
		}
	}
}