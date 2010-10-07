package com.udox.mp3player
{
	import com.udox.mp3player.controller.MP3Player;
	import com.udox.mp3player.controller.PlaylistLoader;
	import com.udox.mp3player.events.ID3Event;
	import com.udox.mp3player.events.PlaylistData;
	import com.udox.mp3player.events.VolumeEvent;
	import com.udox.mp3player.model.Track;
	import com.udox.mp3player.view.PlayButton;
	import com.udox.mp3player.view.PlaylistControl;
	import com.udox.mp3player.view.ProgressBar;
	import com.udox.mp3player.view.VolumeControl;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.events.ListEventReason;
	
	public class VansRadioPlayer extends Sprite
	{
		
		[Embed(source="../assets/background.png")]
		private static var BackgroundPNG:Class;
		public var backgroundBmp:Bitmap;
		
		public var mp3:MP3Player = new MP3Player();
		
		public var playButton:PlayButton;
		public var progressBar:ProgressBar;
		public var volumeControl:VolumeControl;
		public var playlistControl:PlaylistControl;
		public var playlistLoader:PlaylistLoader;
		
		public var baseUrl:String = 'http://vans-fb-media.u-dox.com/';

		public function VansRadioPlayer()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			playlistLoader = new PlaylistLoader('http://media.vans:8080/audio/playlist.xml');
			playlistLoader.addEventListener(PlaylistData.PLAYLIST, onPlaylistData);
			playlistLoader.loadData();
			
			backgroundBmp = new BackgroundPNG();
			addChild(backgroundBmp);
			
			progressBar = new ProgressBar()
			progressBar.x = 40;
			progressBar.y = 23;
			addChild(progressBar);
			
			playButton = new PlayButton();
			playButton.addEventListener(MouseEvent.CLICK, on_playButton_click);
			playButton.x = 6;
			playButton.y = 14;
			addChild(playButton);
			
			volumeControl = new VolumeControl();
			volumeControl.x = 223;
			volumeControl.y = 25;
			volumeControl.addEventListener(VolumeEvent.VOLUME, onVolume);
			addChild(volumeControl);
			
			playlistControl = new PlaylistControl();
			playlistControl.x = 17;
			playlistControl.y = 196;
//			playlistControl.playlist = labels;
			playlistControl.addEventListener(ListEvent.CHANGE, onPlaylistChange);
			addChild(playlistControl);
			
//			mp3.playlist = urls;
			mp3.addEventListener(MP3Player.EVENT_PLAYLIST_FINISH, onPlaylistFinish);
			mp3.addEventListener(MP3Player.EVENT_PLAY, onPlay);
			mp3.addEventListener(MP3Player.EVENT_TIME_CHANGE, onTimeChange);
			mp3.addEventListener(ID3Event.ID3EVENT, onID3);
		}
		
		public function on_playButton_click(evt:MouseEvent):void
		{
			if (mp3.playing) {
				mp3.pause();
				setNotPlaying();
			} else {
				mp3.unpause();
				setPlaying();
			}
		}
		private function setNotPlaying():void
		{
			mp3.removeEventListener(MP3Player.EVENT_TIME_CHANGE, onProgress);
			playButton.playing = false;
		}
		private function setPlaying():void
		{
			mp3.addEventListener(MP3Player.EVENT_TIME_CHANGE, onProgress);
			playButton.playing = true;
		}
		
		public function onProgress(evt:Event):void
		{
			progressBar.progress = mp3.timePercent;
		}
		
		public function onPlay(evt:Event):void
		{
			progressBar.setText('');
			trace('onPlay', mp3.playlistIndex);
			playlistControl.list.selectedIndex = mp3.playlistIndex;// -> ListEventReason.OTHER
		}
		
		public function onPlaylistFinish(evt:Event):void
		{
			trace('onPlaylistFinish');
			mp3.removeEventListener(MP3Player.EVENT_TIME_CHANGE, onProgress);
			playButton.playing = false;
		}
		
		public function onID3(evt:ID3Event):void
		{
			trace(evt.id3info.artist, evt.id3info.songName);
			progressBar.setText(evt.id3info.artist + ' - ' + evt.id3info.songName);
		}
		
		public function onVolume(evt:VolumeEvent):void
		{
			trace('onVolume', evt.volumePercent);
			mp3.volume = evt.volumePercent / 100;
		}
		
		public function onPlaylistChange(evt:ListEvent):void
		{
			// not called if you click on currently playing track
			trace('onPlaylistChange', evt.reason, playlistControl.currentIndex);
			if (evt.reason != ListEventReason.OTHER) {
				mp3.pause();
				setNotPlaying();
				mp3.playlistIndex = playlistControl.currentIndex;
				mp3.play(mp3.playlist[mp3.playlistIndex]);
				setPlaying();
			}
		}
		
		public function onPlaylistData(evt:PlaylistData):void
		{
			trace('onPlaylistData', evt.playlist.tracks);
			playlistControl.playlist = evt.playlist.getTracks('<font color="#ce4f57" size="+2">%(artist)s</font> %(title)s');
			mp3.playlist = evt.playlist.getTracks('%(location)s');
		}
	}
}