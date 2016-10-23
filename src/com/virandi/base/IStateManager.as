
package com.virandi.base
{
	public interface IStateManager
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		function ChangeState (state:IState) : IStateManager
		
		function ClearState () : IStateManager
		
		function PopState () : IStateManager
		
		function PushState (state:IState) : IStateManager
		
		function RestartState () : IStateManager
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
