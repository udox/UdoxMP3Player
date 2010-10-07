// From http://unformatt.com/news/as3-mp3-player/
package com.udox.mp3player.controller {
	import com.udox.mp3player.events.ID3Event;
	import org.openPyro.utils.StringUtil;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class MP3Player extends EventDispatcher {
		
		static public const EVENT_TIME_CHANGE:String = 'Mp3Player.TimeChange';
		static public const EVENT_VOLUME_CHANGE:String = 'Mp3Player.VolumeChange';
		static public const EVENT_PAN_CHANGE:String = 'Mp3Player.PanningChange';
		static public const EVENT_PAUSE:String = 'Mp3Player.Pause';
		static public const EVENT_UNPAUSE:String = 'Mp3Player.Unpause';
		static public const EVENT_PLAY:String = 'Mp3Player.Play';
		static public const EVENT_PLAYLIST_FINISH:String = 'Mp3Player.PlaylistFinish';
		//
		public var playing:Boolean;
		public var playlist:Array;
		public var currentUrl:String;
		public var playlistIndex:int = -1;
		public var loopPlaylist:Boolean = false;
		//
		protected var sound:Sound;
		protected var soundChannel:SoundChannel;
		protected var soundTrans:SoundTransform;
		protected var progressInt:Number;
		private var _timePercent:Number = 0;
		private var _lastTimePercent:Number = 0;
		
		public function play( url:String ):void {
			trace('play()');
			clearInterval(progressInt);
			if ( sound ) {
				stopSound();
			}
			currentUrl = url;
			sound = new Sound();
			sound.addEventListener(Event.COMPLETE, onLoadSong);
			sound.addEventListener(Event.ID3, onId3Info);
			
			sound.load(new URLRequest(currentUrl));
			
			soundChannel = sound.play();
			if ( soundTrans ) {
				soundChannel.soundTransform = soundTrans;
			} else {
				soundTrans = soundChannel.soundTransform;
			}
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSongEnd);
			playing = true;
			_timePercent = 0
			_lastTimePercent = 0
			progressInt = setInterval(updateProgress, 250);
			dispatchEvent(new Event(EVENT_PLAY));
		}
		public function pause():void {
			trace('pause');
			if ( soundChannel ) {
				trace('soundChannel:', soundChannel, 'sound:', sound);
				stopSound();
				dispatchEvent(new Event(EVENT_PAUSE));
			}
		}
		public function unpause():void {
			trace('unpause');
			if ( playing ) return;
			trace('wasn\'t playing');
			if ( ! sound ) {
				trace('no sound obj');
				playlistIndex = 0;
				play(playlist[0]);
				return;
			}
			if ( soundChannel.position < sound.length ) {
				soundChannel = sound.play(soundChannel.position);
				soundChannel.soundTransform = soundTrans;
			} else {
				soundChannel = sound.play();
			}
			dispatchEvent(new Event(EVENT_UNPAUSE));
			playing = true;
			progressInt = setInterval(updateProgress, 250);
		}
		public function seek( percent:Number ):void {
			stopSound();
			soundChannel = sound.play(sound.length * (percent / 100));
		}
		public function prev():void {
			playlistIndex--;
			if ( playlistIndex < 0 ) playlistIndex = playlist.length - 1;
			play(playlist[playlistIndex]);
		}
		public function next():void {
			playlistIndex++;
			if ( playlistIndex == playlist.length ) playlistIndex = 0;
			play(playlist[playlistIndex]);
		}
		public function get volume():Number {
			if (!soundTrans) return 0;
			return soundTrans.volume;
		}
		public function set volume( n:Number ):void {
			if ( !soundTrans ) return;
			soundTrans.volume = n;
			soundChannel.soundTransform = soundTrans;
			dispatchEvent(new Event(EVENT_VOLUME_CHANGE));
		}
		public function get pan():Number {
			if (!soundTrans) return 0;
			return soundTrans.pan;
		}
		public function set pan( n:Number ):void {
			if ( !soundTrans ) return;
			soundTrans.pan = n;
			soundChannel.soundTransform = soundTrans;
			dispatchEvent(new Event(EVENT_PAN_CHANGE));
		}
		public function get length():Number {
			return sound.length;
		}
		public function get time():Number {
			return soundChannel.position;
		}
		
		/**
		 * Return nicely formatted time String from milliseconds Number
		 * (e.g. this.length or this.time)
		 */
		public static function prettify(milliseconds:Number, padMins:Boolean=false):String
		{
			var secs:Number = milliseconds / 1000;
			var mins:Number = Math.floor(secs / 60);
			secs = Math.floor(secs % 60);
			secs = StringUtil.padLeading(secs.toString(), 2, '0');
			if (padMins) {
				mins = StringUtil.padLeading(mins.toString(), 2, '0');
			}
			return mins + ":" + secs;
		}
		
		public function get timePercent():Number {
			if ( sound ) {
				if ( !sound.length ) return 0;
				_timePercent = (soundChannel.position / sound.length) * 100;
			}
			return _timePercent;
		}
		protected function onLoadSong( e:Event ):void {
			trace('onLoadSong');
		}
		protected function onSongEnd( e:Event ):void {
			trace('onSongEnd', playlistIndex, playlist.length);
			if ( playlist && (playlistIndex < playlist.length - 1 || loopPlaylist) ) {
				next();
			} else {
				stopSound();
				sound = null;
				playlistIndex = 0;
				dispatchEvent(new Event(EVENT_PLAYLIST_FINISH));
			}
		}
		protected function onId3Info( e:Event ):void {
			dispatchEvent(new ID3Event(e.target.id3));
		}
		protected function updateProgress():void {
			dispatchEvent(new Event(EVENT_TIME_CHANGE));
			if ( timePercent >= 95 && _timePercent == _lastTimePercent ) {
				onSongEnd(new Event(Event.COMPLETE));
			}
			_lastTimePercent = _timePercent;
		}
		
		private function stopSound():void
		{
			clearInterval(progressInt);
			soundChannel.stop();
			playing = false;
			try {sound.close();}catch(error:IOError){trace(error);}
		}
	}	
}