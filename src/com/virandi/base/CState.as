
package com.virandi.base
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CState extends Sprite implements IHandleEvent, IRender, IState, IUpdate
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var gui:CGUI = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CState ()
		{
			super ();
			
			this.gui = new CGUI ();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function HandleEvent (event:Event) : IHandleEvent
		{
			this.gui.HandleEvent (event);
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Render () : IRender
		{
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DeInitialize () : IState
		{
			this.removeChild ((this.gui.DeInitialize () as CGUI));
			
			return this;
		}
		
		public function Initialize () : IState
		{
			this.addChild ((this.gui.Initialize () as CGUI));
			
			return this;
		}
		
		public function Pause () : IState
		{
			this.gui.Pause ();
			
			return this;
		}
		
		public function Resume () : IState
		{
			this.gui.Resume ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Update () : IUpdate
		{
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
