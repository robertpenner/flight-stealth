package flight.containers
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.data.IRange;
	import flight.data.IScroll;
	import flight.data.Scroll;
	import flight.measurement.resolveHeight;
	import flight.measurement.resolveWidth;
	import flight.metadata.resolveCommitProperties;
	
	public class Scroller extends Group
	{
		protected var dataBind:DataBind = new DataBind();
		
		private var _horizontal:IScroll;
		private var _vertical:IScroll;
		private var _container:DisplayObject
		
		private var shape:Shape; // temporary
		
		[Bindable(event="horizontalChange")]
		public function get horizontal():IScroll { return _horizontal; }
		public function set horizontal(value:IScroll):void {
			DataChange.change(this, "horizontal", _horizontal, _horizontal = value);
		}
		
		[Bindable(event="verticalChange")]
		public function get vertical():IScroll { return _vertical; }
		public function set vertical(value:IScroll):void {
			DataChange.change(this, "vertical", _vertical, _vertical = value);
		}
		
		[Bindable(event="containerChange")]
		public function get container():DisplayObject { return _container; }
		public function set container(value:DisplayObject):void {
			if(_container) { this.removeChild(_container); }
			DataChange.queue(this, "container", _container, _container = value);
			if(_container) { this.addChild(_container); }
			DataChange.change();
		}
		
		public function Scroller()
		{
			horizontal = new Scroll();
			vertical = new Scroll();
			flight.metadata.resolveCommitProperties(this);
			dataBind.bindSetter(onHorizontalScroll, this, "horizontal.position");
			dataBind.bindSetter(onVerticalScroll, this, "vertical.position");
		}
		
		/**
		 * @private
		 **/
		// If we keep position by percent, what happens when the scrolled object's size changes? (That's a rhetorical question.)
		[CommitProperties(target="container, vertical, horizontal, container.height, container.width")]
		public function onContainerChange(event:Event):void {
			horizontal.min = vertical.min = 0;
			measured.width = horizontal.max = flight.measurement.resolveWidth(container);
			measured.height = vertical.max = flight.measurement.resolveHeight(container);
			if(horizontal is IScroll) {
				(horizontal as IScroll).pageSize = unscaledWidth;
			}
			if(vertical is IScroll) {
				(vertical as IScroll).pageSize = unscaledHeight;
			}
			shape = new Shape();
			shape.graphics.beginFill(0, 0);
			shape.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			shape.graphics.endFill();
			this.addChild(shape);
			this.mask = shape;
		}
		
		private function onVerticalScroll(value:Object):void {
			if(vertical && container) {
				var height:Number = flight.measurement.resolveHeight(container);
				var potential:Number = height - unscaledHeight;
				var percent:Number = (vertical.position-vertical.min) /(vertical.max-vertical.min);
				container.y = potential * percent * -1; // ui specific calcs are here, where the ui specific code is.
			}
		}
		
		private function onHorizontalScroll(value:Object):void {
			if(horizontal && container) {
				var width:Number = flight.measurement.resolveWidth(container);
				var potential:Number = width - unscaledWidth;
				var percent:Number = (horizontal.position-horizontal.min) /(horizontal.max-horizontal.min);
				container.x = potential * percent * -1; // ui specific calcs are here, where the ui specific code is.
			}
		}
	}
}