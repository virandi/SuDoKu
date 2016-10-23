
package com.virandi.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;
	
	public dynamic class CGUI extends Sprite implements IHandleEvent, IState
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public const BUTTON_ON_MOUSE_DOWN:int = 3;
		
		static public const BUTTON_ON_MOUSE_OUT:int = 1;
		
		static public const BUTTON_ON_MOUSE_OVER:int = 2;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var displayObjectContainer:DisplayObjectContainer = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CGUI ()
		{
			super ();
			
			this.displayObjectContainer = null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function HandleEvent (event:Event) : IHandleEvent
		{
			var flag:Boolean = false;
			
			var i:int = 0;
			
			if ((event is MouseEvent) || (event is TouchEvent))
			{
				if ((event.target is MovieClip) && (event.target.name.indexOf ("MC_BUTTON", 0) != -1))
				{
					switch (event.type)
					{
						case MouseEvent.CLICK :
						case TouchEvent.TOUCH_TAP :
						{
							if (event.target.parent.name.indexOf ("MC_BUTTON_SELECT", 0) == -1)
							{
							}
							else
							{
								flag = (event.target.currentFrame == event.target.totalFrames);
								
								for (i = 0; i != event.target.parent.numChildren; ++i)
								{
									if ((event.target.parent.getChildAt (i) is MovieClip) && (event.target.parent.getChildAt (i).name.indexOf ("MC_BUTTON", 0) != -1))
									{
										event.target.parent.getChildAt (i).gotoAndStop (1, null);
									}
								}
								
								if (flag == false)
								{
									event.target.gotoAndStop (event.target.totalFrames, null);
								}
								else
								{
									event.target.gotoAndStop ((event.target.currentFrame + 1), null);
								}
							}
							
							break;
						}
						case MouseEvent.MOUSE_OUT :
						case TouchEvent.TOUCH_OUT :
						{
							event.target.gotoAndStop ((event.target.currentFrame - 1), null);
							
							break;
						}
						case MouseEvent.MOUSE_OVER :
						case TouchEvent.TOUCH_OVER :
						{
							event.target.gotoAndStop ((event.target.currentFrame + 1), null);
							
							break;
						}
						default :
						{
							break;
						}
					}
				}
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DeInitialize () : IState
		{
			var displayObject:DisplayObject = null;
			
			var i:int = 0;
			
			var openList:Vector.<DisplayObject> = new Vector.<DisplayObject> ();
			
			openList.push (this);
			
			for (; openList.length != 0; )
			{
				displayObject = openList.shift ();
				
				if (displayObject is DisplayObjectContainer)
				{
					for (i = 0; i != (displayObject as DisplayObjectContainer).numChildren; ++i)
					{
						if ((displayObject as DisplayObjectContainer).getChildAt (i) is DisplayObjectContainer)
						{
							openList.push ((displayObject as DisplayObjectContainer).getChildAt (i));
						}
					}
				}
				
				this [displayObject] = null;
			}
			
			this.removeChildren (0, int.MAX_VALUE);
			
			return this;
		}
		
		public function Initialize () : IState
		{
			var displayObject:DisplayObject = null;
			
			var i:int = 0;
			
			var j:int = 0;
			
			var openList:Vector.<DisplayObject> = null;
			
			var scale:Number = 0.0;
			
			this.DeInitialize ();
			
			if (this.displayObjectContainer == null)
			{
			}
			else
			{
				openList = new <DisplayObject> [this];
				
				this.addChild (this.displayObjectContainer);
				
				for (i = 0; i != openList.length; ++i)
				{
					displayObject = openList [i];
					
					if (displayObject is DisplayObjectContainer)
					{
						for (j = 0; j != (displayObject as DisplayObjectContainer).numChildren; ++j)
						{
							if ((displayObject as DisplayObjectContainer).getChildAt (j))
							{
								openList.push ((displayObject as DisplayObjectContainer).getChildAt (j));
							}
						}
						
						if (displayObject is MovieClip)
						{
							(displayObject as MovieClip).buttonMode = (displayObject as MovieClip).useHandCursor = !(displayObject.name.indexOf ("MC_BUTTON", 0) == -1);
							
							(displayObject as MovieClip).gotoAndStop (1, null);
							
							if ((this.stage == null) || (((displayObject as MovieClip).buttonMode == false) || ((displayObject as MovieClip).useHandCursor == false)) || ((displayObject as MovieClip).hitTestPoint (this.stage.mouseX, this.stage.mouseY, true) == false))
							{
							}
							else
							{
								(displayObject as MovieClip).gotoAndStop (((displayObject as MovieClip).currentFrame + 1), null);
							}
						}
					}
					
					this [displayObject.name] = displayObject;
				}
			}
			
			return this;
		}
		
		public function Pause () : IState
		{
			return this;
		}
		
		public function Resume () : IState
		{
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
