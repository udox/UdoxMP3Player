package com.udox.mp3player.view
{
	import com.udox.mp3player.skin.ListRenderer;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.controls.List;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.Stroke;
	import org.openPyro.painters.StrokePainter;
	import org.openPyro.utils.StringUtil;
	
	public class PlaylistControl extends Sprite
	{
		public var list:List;
		
		public function PlaylistControl()
		{
			// Create a new List 
			var rendererFactory:ClassFactory = new ClassFactory(ListRenderer);
			rendererFactory.properties = {percentUnusedWidth:100, height:22};
			
			list = new List();
			list.itemRenderer = rendererFactory;
			list.width = 276;
			list.height = 132;
			list.borderStrokePainter = new StrokePainter(new Stroke(NaN));
			list.backgroundPainter = new FillPainter(0x580004);
			list.labelFunction = function(val:*):String {
				var s:String = StringUtil.toStringLabel(val);
				return s.toUpperCase();
			}
			list.addEventListener(ListEvent.CHANGE, onListChange);
			
			var listMask:Shape = new Shape();
			listMask.graphics.beginFill(0xffffff);
			listMask.graphics.drawRoundRect(0,0, 276,132, 3,3);
			listMask.graphics.endFill();
			addChild(listMask);
			
			list.mask = listMask;
			addChild(list);
		}
		
		public function set playlist(pl:Object):void
		{
			list.dataProvider = pl;
		}
		public function get playlist():Object {
			return list.dataProvider;
		}
		
		public function get currentUrl():String {
			return String(list.selectedItem);
		}
		public function get currentIndex():int {
			return list.selectedIndex;
		}
		
		public function onListChange(evt:ListEvent):void
		{
			var newEvt:ListEvent = new ListEvent(ListEvent.CHANGE);
			newEvt.reason = evt.reason;
			dispatchEvent(newEvt);
		}
	}
}