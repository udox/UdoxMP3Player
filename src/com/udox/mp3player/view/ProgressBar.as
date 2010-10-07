package com.udox.mp3player.view
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class ProgressBar extends Sprite
	{
		[Embed(source="../assets/BEBAS.ttf", fontName="_Bebas")]
		public var _Bebas:String;
		
		[Embed(source="../assets/progress-shadow.png")]
		private static var ShadowPNG:Class;
		public var shadowBmp:Bitmap;
		
		private var progressBar:Shape;
		
		private var songText:TextField;
		public var songText_x:Number = 8;
		public var songText_rPad:Number = 4;
		public var songText_y:Number = 2;
		public var marqueeTravel:Number;
		public var marqueeDirection:int = -1;
		public var marqueeIncrement:Number = 0.75;
		public var marqueeWaitFrames:int = 20;
		private var marqueeWaitCount:int = 0;
		
		public var barWidth:Number = 180;
		public var barHeight:Number = 24;
		
		private var _progress:int = 0;
		public function get progress():int { return _progress; }
		public function set progress(val:int):void
		{
			_progress = val;
			var width:Number = (val / 100) * barWidth;
			progressBar.graphics.clear();
			progressBar.graphics.beginFill(0xce4f57);
			progressBar.graphics.drawRoundRect(0,0, width,barHeight, 3,3);
			progressBar.graphics.endFill();
		}
		
		public function ProgressBar()
		{
			graphics.clear();
			
			// draw background colour panel
			graphics.beginFill(0x7f0515);
			graphics.drawRoundRect(0,0, barWidth,barHeight, 3,3);
			graphics.endFill();
			
			// draw progress bar
			progressBar = new Shape();
			addChild(progressBar);
			
			// make empty song title field
			songText = new TextField();
			songText.autoSize = TextFieldAutoSize.LEFT;
			songText.textColor = 0xffffff;
			songText.embedFonts = true;
			songText.x = songText_x;
			songText.y = songText_y;
			var tf:TextFormat = new TextFormat();
			tf.font = '_Bebas';
			tf.letterSpacing = -0.7;
			songText.defaultTextFormat = tf;
			
			var textMask:Shape = new Shape();
			textMask.graphics.beginFill(0xffffff);
			textMask.graphics.drawRoundRect(0,0, barWidth,barHeight, 3,3);
			textMask.graphics.endFill();
			addChild(textMask);
			
			songText.mask = textMask;
			addChild(songText);
			
			// draw inner shadow on top
			var shadowMask:Shape = new Shape();
			shadowMask.graphics.beginFill(0xffffff);
			shadowMask.graphics.drawRoundRect(0,0, barWidth,barHeight, 3,3);
			shadowMask.graphics.endFill();
			addChild(shadowMask);
			
			shadowBmp = new ShadowPNG();
			shadowBmp.mask = shadowMask;
			addChild(shadowBmp);
			
			// draw outline
			graphics.lineStyle(1, 0xbb3942);
			graphics.drawRoundRect(0,0, barWidth,barHeight, 3,3);
			graphics.endFill();
		}
		
		public function setText(text:String):void
		{
			stopMarquee();
			songText.text = text.toUpperCase();
			trace(songText.width);
			if (songText.width > barWidth) {
				startMarquee();
			}
		}
		
		public function startMarquee():void
		{
			marqueeTravel = songText.width - barWidth + songText_x;
			addEventListener(Event.ENTER_FRAME, marqueeSetPos);
		}
		
		public function stopMarquee():void
		{
			removeEventListener(Event.ENTER_FRAME, marqueeSetPos);
			songText.x = songText_x;
		}
		
		public function marqueeSetPos(evt:Event):void
		{
			if (songText.x <= songText_x - marqueeTravel - songText_rPad) {
				marqueeDirection = 1;
				if (!marqueeContinue()) return;
			} else
			if (songText.x >= songText_x) {
				marqueeDirection = -1;
				if (!marqueeContinue()) return;
			}
			if (marqueeDirection < 0) {
				if (songText.x > songText_x - marqueeTravel - songText_rPad) {
					songText.x = songText.x - marqueeIncrement;
				}
			} else {
				if (songText.x < songText_x) {
					songText.x = songText.x + marqueeIncrement;
				}
			}
		}
		
		private function marqueeContinue():Boolean {
			if (marqueeWaitCount < marqueeWaitFrames) {
				marqueeWaitCount++;
				return false;
			} else {
				marqueeWaitCount = 0;
				return true;
			}
		}
	}
}