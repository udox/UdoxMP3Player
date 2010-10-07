package com.udox.mp3player.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import com.udox.mp3player.events.VolumeEvent;
	
	public class VolumeControl extends Sprite
	{
		public var barWidth:Number = 6;
		public var barHeight:Number = 20;
		
		public var bars:Array = [];
		
		private var onColor:ColorTransform;
		private var offColor:ColorTransform;
		
		private var _vPercent:Number;
		public function get vPercent():Number { return _vPercent; }
		public function set vPercent(num:Number):void
		{
			_vPercent = Math.max(Math.min(num, 100), 0);
			var bar:int = Math.round(num / 25);
			for (var i:int = 0; i < 4; i++) {
				if (i < bar) {
					bars[i].transform.colorTransform = onColor;
				} else {
					bars[i].transform.colorTransform = offColor;
				}
			}
		}
		
		public function VolumeControl()
		{
			for (var i:int=0; i < 4; i++) {
				var bar:VolumeControlBar = new VolumeControlBar();
				bar.x = i * (barWidth + 2);
				bar.graphics.beginFill(0xce4f57);
				bar.graphics.drawRoundRect(0,0, barWidth,barHeight, 2,2);
				bar.graphics.endFill();
				bar.index = i;
				bar.addEventListener(MouseEvent.CLICK, onBarClick);
				bars[i] = addChild(bar);
			}
			offColor = new ColorTransform();
			offColor.color = 0xce4f57;
			onColor = new ColorTransform();
			onColor.color = 0xf3abad;
			
			vPercent = 100;
		}
		
		public function onBarClick(evt:MouseEvent):void
		{
			var bar:VolumeControlBar = VolumeControlBar(evt.target);
			vPercent = (bar.index + 1) * 25;
			dispatchEvent(new VolumeEvent(vPercent));
		}
	}
}