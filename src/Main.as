
/*
 * what		: SuDoKu
 * when		: ..
 * where	: in your sincere heart
 * who		: yusuf rizky virandi @ .virandi. studio
 *
 * license	: knowledge belongs to the world..
 */

package
{
	import com.virandi.base.CMain;
	import com.virandi.base.IState;
	import com.virandi.sudoku.core.Board;
	
	public class Main extends CMain
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var board:Board = null;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Main ()
		{
			super ();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function DeInitialize () : IState
		{
			super.DeInitialize ();
			
			return this;
		}
		
		override public function Initialize () : IState
		{
			super.Initialize ();
			
			this.board = new Board ().Create (9).Solve ().Print ();
			
			return this;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
