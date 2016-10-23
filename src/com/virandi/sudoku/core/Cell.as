
package com.virandi.sudoku.core
{
	public class Cell
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var available:Vector.<int> = null;
		
		public var index:int = 0;
		
		public var invalid:Vector.<int> = null;
		
		public var lock:Boolean = false;
		
		public var value:uint = 0;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Cell (index:int, size:int)
		{
			super ();
			
			this.available = new Vector.<int> ();
			
			this.index = index;
			
			this.invalid = new Vector.<int> ((size + 1));
			
			this.lock = false;
			
			this.value = 0;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function toString () : String
		{
			return this.value.toString ();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
