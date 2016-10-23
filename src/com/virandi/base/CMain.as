
package com.virandi.base
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class CMain extends Sprite implements IHandleEvent, IState, IStateManager
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var mouse:Object = null;
		
		public var state:Vector.<IState> = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get Height () : Number
		{
			return 1.0;
		}
		
		public function get Width () : Number
		{
			return 1.0;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CMain ()
		{
			super ();
			
			this.mouse = new Object ();
			
			this.state = new Vector.<IState> ();
			
			this.addEventListener (Event.ADDED_TO_STAGE, this.HandleEvent, false, 0, false);
			this.addEventListener (Event.REMOVED_FROM_STAGE, this.HandleEvent, false, 0, false);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Multitouch.mapTouchToMouse = true;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function HandleEvent (event:Event) : IHandleEvent
		{
			var i:int = 0;
			
			var state:IState = null;
			
			switch (event.currentTarget)
			{
				case this :
				{
					switch (event.type)
					{
						case Event.ADDED_TO_STAGE :
						{
							this.Initialize ();
							
							break;
						}
						case Event.REMOVED_FROM_STAGE :
						{
							break;
						}
						default :
						{
							break;
						}
					}
					
					break;
				}
				case this.stage :
				{
					switch (event.type)
					{
						case Event.ACTIVATE :
						{
							if (this.state.length == 0)
							{
							}
							else
							{
								this.state [0].Resume ();
							}
							
							break;
						}
						case Event.DEACTIVATE :
						{
							if (this.state.length == 0)
							{
							}
							else
							{
								this.state [0].Pause ();
							}
							
							break;
						}
						case Event.ENTER_FRAME :
						{
							if (this.state.length == 0)
							{
							}
							else
							{
								for (i = this.state.length; i != 0; )
								{
									state = this.state [--i];
									
									if (state is IRender)
									{
										(state as IRender).Render ();
									}
								}
								
								if (state is IUpdate)
								{
									(state as IUpdate).Update ();
								}
							}
							
							this.mouse.move = false;
							this.mouse.speed.x = this.mouse.speed.y = 0.0;
							
							break;
						}
						case Event.RESIZE :
						{
							this.scaleX = this.scaleY = Math.min ((this.stage.stageHeight / this.Height), (this.stage.stageWidth / this.Width));
							
							this.x = ((this.stage.stageWidth - (this.Width * this.scaleX)) * 0.5);
							this.y = ((this.stage.stageHeight - (this.Height * this.scaleY)) * 0.5);
							
							break;
						}
						case KeyboardEvent.KEY_DOWN :
						{
							switch ((event as KeyboardEvent).keyCode)
							{
								case Keyboard.ESCAPE :
								{
									event.preventDefault ();
									
									event.stopImmediatePropagation ();
									
									break;
								}
								default :
								{
									break;
								}
							}
							
							break;
						}
						case MouseEvent.CLICK :
						case TouchEvent.TOUCH_TAP :
						{
							this.mouse.click = this.mouse.click;
							
							break;
						}
						case MouseEvent.MOUSE_DOWN :
						case TouchEvent.TOUCH_BEGIN :
						{
							this.mouse.click = true;
							this.mouse.down = true;
							
							this.mouse.position = (this.globalToLocal (new Point ((event as Object).stageX, (event as Object).stageY)));
							
							break;
						}
						case MouseEvent.MOUSE_MOVE :
						case TouchEvent.TOUCH_MOVE :
						{
							this.mouse.speed.x = (this.globalToLocal (new Point ((event as Object).stageX, (event as Object).stageY)).x - this.mouse.position.x);
							this.mouse.speed.y = (this.globalToLocal (new Point ((event as Object).stageX, (event as Object).stageY)).y - this.mouse.position.y);
							
							this.mouse.position = (this.globalToLocal (new Point ((event as Object).stageX, (event as Object).stageY)));
							
							this.mouse.move = true;
							this.mouse.click = false;
							
							break;
						}
						case MouseEvent.MOUSE_UP :
						case TouchEvent.TOUCH_END :
						{
							this.mouse.down = false;
							this.mouse.click = this.mouse.click;
							
							break;
						}
						default :
						{
							break;
						}
					}
					
					break;
				}
				case NativeApplication.nativeApplication :
				{
					switch (event.type)
					{
						case Event.EXITING :
						{
							break;
						}
						default :
						{
							break;
						}
					}
					
					break;
				}
				default :
				{
					break;
				}
			}
			
			if (this.state.length == 0)
			{
			}
			else
			{
				state = this.state [0];
				
				if (state is IHandleEvent)
				{
					(state as IHandleEvent).HandleEvent (event);
				}
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DeInitialize () : IState
		{
			this.ClearState ();
			
			NativeApplication.nativeApplication.exit (0);
			
			return this;
		}
		
		public function Initialize () : IState
		{
			this.mouse.click = false;
			this.mouse.down = false;
			this.mouse.move = false;
			this.mouse.position = {x:this.stage.mouseX, y:this.stage.mouseY};
			this.mouse.speed = {x:0.0, y:0.0};
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.displayState = StageDisplayState.NORMAL;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.stage.addEventListener (Event.ACTIVATE, this.HandleEvent, false, 0, false);
			this.stage.addEventListener (Event.DEACTIVATE, this.HandleEvent, false, 0, false);
			this.stage.addEventListener (Event.ENTER_FRAME, this.HandleEvent, false, 0, false);
			this.stage.addEventListener (Event.RESIZE, this.HandleEvent, false, 0, false);
			this.stage.addEventListener (KeyboardEvent.KEY_DOWN, this.HandleEvent, false, 0, false);
			this.stage.addEventListener (KeyboardEvent.KEY_UP, this.HandleEvent, false, 0, false);
			
			switch (Capabilities.touchscreenType)
			{
				case TouchscreenType.NONE :
				{
					break;
				}
				default :
				{
					this.stage.addEventListener (MouseEvent.CLICK, this.HandleEvent, false, 0, false);
					this.stage.addEventListener (MouseEvent.MOUSE_DOWN, this.HandleEvent, false, 0, false);
					this.stage.addEventListener (MouseEvent.MOUSE_MOVE, this.HandleEvent, false, 0, false);
					this.stage.addEventListener (MouseEvent.MOUSE_OUT, this.HandleEvent, false, 0, false);
					this.stage.addEventListener (MouseEvent.MOUSE_OVER, this.HandleEvent, false, 0, false);
					this.stage.addEventListener (MouseEvent.MOUSE_UP, this.HandleEvent, false, 0, false);
					this.stage.addEventListener (MouseEvent.MOUSE_WHEEL, this.HandleEvent, false, 0, false);
					
					//this.stage.addEventListener (TouchEvent.TOUCH_BEGIN, this.HandleEvent, false, 0, false);
					//this.stage.addEventListener (TouchEvent.TOUCH_END, this.HandleEvent, false, 0, false);
					//this.stage.addEventListener (TouchEvent.TOUCH_MOVE, this.HandleEvent, false, 0, false);
					//this.stage.addEventListener (TouchEvent.TOUCH_OUT, this.HandleEvent, false, 0, false);
					//this.stage.addEventListener (TouchEvent.TOUCH_OVER, this.HandleEvent, false, 0, false);
					//this.stage.addEventListener (TouchEvent.TOUCH_TAP, this.HandleEvent, false, 0, false);
					
					break;
				}
			}
			
			NativeApplication.nativeApplication.addEventListener (Event.EXITING, this.HandleEvent, false, 0, false);
			
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
		
		public function ClearState () : IStateManager
		{
			for (; this.state.length != 0; )
			{
				this.PopState ();
			}
			
			return this;
		}
		
		public function ChangeState (state:IState) : IStateManager
		{
			if ((state as CState) == null)
			{
			}
			else
			{
				if (this.state.length == 0)
				{
				}
				else
				{
					this.state.shift ().DeInitialize ();
				}
				
				this.state.unshift (state);
				
				this.state [0].Initialize ();
				
				this.addChild ((this.state [0] as CState));
			}
			
			return this;
		}
		
		public function PopState () : IStateManager
		{
			if (this.state.length == 0)
			{
			}
			else
			{
				this.state.shift ().DeInitialize ();
				
				if (this.state.length == 0)
				{
				}
				else
				{
					this.state [0].Resume ();
				}
			}
			
			return this;
		}
		
		public function PushState (state:IState) : IStateManager
		{
			if ((state as CState) == null)
			{
			}
			else
			{
				if (this.state.length == 0)
				{
				}
				else
				{
					this.state [0].Pause ();
				}
				
				this.state.unshift (state);
				
				this.state [0].Initialize ();
				
				this.addChild ((this.state [0] as CState));
			}
			
			return this;
		}
		
		public function RestartState () : IStateManager
		{
			if (this.state.length == 0)
			{
			}
			else
			{
				this.state [0].DeInitialize ().Initialize ();
			}
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
