package com.udox.mp3player.skin
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openPyro.controls.listClasses.BaseListData;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.managers.SkinManager;
	import org.openPyro.painters.FillPainter;
	
	public class ListRenderer extends DefaultListRenderer
	{
		[Embed(source="../assets/ITCAvantGardeStd-Bold.otf", fontName="_AvantGarde", fontWeight="bold")] 
		public var _font:String;
		
		public var labelYOffset:Number = 0;
		
		public function ListRenderer()
		{
			super();
			
			_rollOverBackgroundPainter = new FillPainter(0x000000);
			
			_labelFormat = new TextFormat(
				'_AvantGarde',
				10,
				0xffffff,
				true
			);
			_labelFormat.letterSpacing = -0.7;
		}
		
		override public function set baseListData(value:BaseListData):void
		{
			if (value.rowIndex % 2 == 0) {
				_backgroundPainter = new FillPainter(0x390001);
			} else {
				_backgroundPainter = new FillPainter(0x580004);
			}
			super.baseListData = value;
		}
		
		override protected function createLabelField():void
		{
			// copy and pasted from super to add embedFonts=true
			_labelField = new TextField()
			_labelField.selectable=false;
			
			if(!_labelFormat){
				_labelField.defaultTextFormat= new TextFormat("Arial",12)
			} 
			else{
				_labelField.defaultTextFormat = _labelFormat;
			}
			_labelField.height = 20;
			_labelField.embedFonts = true;
			addChild(_labelField);
		}

		override protected function createChildren():void
		{
			// copy and pasted from super to set htmlText instead of text
			super.createChildren();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler)
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler)
			
			createLabelField();
			
			if(_data && _baseListData && _baseListData.list){
				_labelField.htmlText = _baseListData.list.labelFunction(_data);
			}
			
			var sk:Object = SkinManager.getInstance().getSkinForStyleName(_styleName);
			
			if(sk && sk.hasOwnProperty("rollOverBackgroundPainter")){
				_rollOverBackgroundPainter = new FillPainter(sk.rollOverBackgroundPainter)
			}
			
			
			if(!_rollOverBackgroundPainter){
				_rollOverBackgroundPainter = new FillPainter(0x559DE6)
			}
			
			if(!_backgroundPainter){
				_backgroundPainter = new FillPainter(0xffffff);
			}
			_highlightCursorSprite = new Sprite();
			addChildAt(_highlightCursorSprite,0);
		}
		
		override public function set data(value:Object):void{
			// copy and pasted from super to set htmlText instead of text
			_data = value;
			if( _baseListData && _baseListData.list){
				_labelField.htmlText =  _baseListData.list.labelFunction(_data);
			}
			else{
				_labelField.htmlText = String(data);
			}
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// copy and pasted from super to add labelYOffset
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_highlightCursorSprite.visible){
				drawHighlightCursor();
			}
			trace('updateDisplayList 1:', _labelField.y);
			_labelField.y = ((unscaledHeight - _labelField.height) / 2) + labelYOffset;
			_labelField.x = 5;
			_labelField.width = unscaledWidth - 10;
			trace('updateDisplayList 2:', _labelField.y);
		}
	}
}