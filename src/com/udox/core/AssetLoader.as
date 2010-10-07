package com.udox.core
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 * The idea is where you need a sprite whose content comes from a URL
	 * you can inherit off this model and it will take care of loading
	 */
	public class AssetLoader extends Sprite
	{
		public var loader:Loader;
		public var loadingAnim:Sprite;
		
		public function AssetLoader(url:String, loadingAnim:Sprite)
		{
			loadingAnim = loadingAnim;
			addChild(loadingAnim);
			trace('loadingAnim.width', loadingAnim.width);
			
			loader = new Loader();
			configureListeners(loader.contentLoaderInfo);
			
			var request:URLRequest = new URLRequest(url);
			loader.load(request);
			
			addChild(loader);
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		private function completeHandler(event:Event):void {
			trace("completeHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		private function initHandler(event:Event):void {
			trace("initHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function unLoadHandler(event:Event):void {
			trace("unLoadHandler: " + event);
		}
	}
}