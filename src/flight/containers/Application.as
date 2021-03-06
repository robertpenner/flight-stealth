package flight.containers
{
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	//[Frame(factoryClass="flight.tools.flashbuilder.StealthApplicationLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	
	/**
	 * @alpha
	 */
	public class Application extends Group
	{
		
		public function Application()
		{
			super();
			if (stage == null) {
				return;
			}
			
			//contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
	}
}