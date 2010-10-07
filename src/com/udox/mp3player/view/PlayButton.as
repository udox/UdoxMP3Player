package com.udox.mp3player.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class PlayButton extends Sprite
	{
		[Embed(source="../assets/play.png")]
		private static var PlayButtonPNG:Class;
		public var playBmp:Bitmap;
		
		[Embed(source="../assets/pause.png")]
		private static var PauseButtonPNG:Class;
		public var pauseBmp:Bitmap;
		
		private var _playing:Boolean = false;
		public function get playing():Boolean { return _playing; }
		public function set playing(val:Boolean):void
		{
			if (_playing != val) {
				trace('set playing:', val);
				playBmp.visible = !val;
				pauseBmp.visible = val;
				_playing = val;
			}
		}
		
		public function PlayButton()
		{
			playBmp = new PlayButtonPNG();
			pauseBmp = new PauseButtonPNG();
			
			pauseBmp.visible = false;
			
			addChild(playBmp);
			addChild(pauseBmp);
		}
	}
}