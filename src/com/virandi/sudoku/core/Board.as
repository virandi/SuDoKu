
package com.virandi.sudoku.core
{
	import mx.utils.StringUtil;
	
	public class Board
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public var cell:Vector.<Cell> = null;
		
		public var data:Vector.<int> = null;
		
		public var size:int = 0;
		
		public var sizeSqrt:int = 0;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Board ()
		{
			super ();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Available (cell:Cell) : Board
		{
			var i:int = 0;
			
			cell.available.length = 0;
			
			for (i = cell.invalid.length; i != 1; )
			{
				((cell.invalid [--i] == 0) ? cell.available.push (i) : null);
			}
			
			return this;
		}
		
		public function Clear () : Board
		{
			var cell:Cell = null;
			
			for each (cell in this.cell)
			{
				cell.lock = false;
				
				this.Put (cell, 0);
			}
			
			return this;
		}
		
		public function Clone () : Board
		{
			return (new Board ().Create (this.size).Copy (this));
		}
		
		public function Copy (board:Board) : Board
		{
			var cell:Cell = null;
			
			this.Create (board.size);
			
			for each (cell in this.cell)
			{
				cell.lock = false;
				{
					this.Put (cell, board.cell [cell.index].value);
				}
				cell.lock = board.cell [cell.index].lock;
			}
			
			return this;
		}
		
		public function Create (size:int) : Board
		{
			var cell:Cell = null;
			
			var i:int = 0;
			
			this.cell = new Vector.<Cell> ((size * size));
			
			this.data = new Vector.<int> ((size * size));
			
			this.size = size;
			
			this.sizeSqrt = Math.sqrt (size);
			
			for (i = 0; i != this.cell.length; ++i)
			{
				this.cell [i] = new Cell (i, size);
				
				this.data [i] = 0;
			}
			
			return this;
		}
		
		public function Fill (data:Vector.<int>) : Board
		{
			var cell:Cell = null;
			
			if (this.cell.length == data.length)
			{
				for each (cell in this.cell)
				{
					if (cell.lock == false)
					{
						this.Put (cell, data [cell.index]);
					}
				}
			}
			
			return this;
		}
		
		public function Load (data:Vector.<int>) : Board
		{
			var cell:Cell = null;
			
			this.Create (int (Math.sqrt (data.length)));
			
			for each (cell in this.cell)
			{
				cell.lock = ((data [cell.index] == 0) ? false : true);
				
				this.Put (cell, data [cell.index]);
			}
			
			return this;
		}
		
		public function Print () : Board
		{
			var i:int = 0;
			
			var j:int = 0;
			
			var strip:String = StringUtil.repeat ("-", (this.size + (this.size - 1)));
			
			trace (strip);
			
			for (i = 0; i != this.size; ++i)
			{
				j = (i * this.size);
				
				trace (this.cell.slice (j, (j + this.size)));
			}
			
			trace (strip);
			
			return this;
		}
		
		public function Put (cell:Cell, value:int) : Board
		{
			var column:int = 0;
			
			var row:int = 0;
			
			var i:int = 0;
			
			var j:int = 0;
			
			var k:int = 0;
			
			var l:int = 0;
			
			var m:int = 0;
			
			var x:int = 0;
			
			var y:int = 0;
			
			if (cell == null)
			{
			}
			else
			{
				if (cell.invalid [value] == 0)
				{
					if (cell.lock == false)
					{
						if (cell.value == value)
						{
						}
						else
						{
							cell.value = (cell.value ^ value);
							
							value = (value ^ cell.value);
							
							cell.value = (cell.value ^ value);
							
							column = (cell.index % this.size);
							
							row = (cell.index / this.size);
							
							x = (column / this.sizeSqrt);
							
							y = (row / this.sizeSqrt);
							
							for (i = 0; i != this.size; ++i)
							{
								j = (i / this.sizeSqrt);
								
								k = ((i % this.sizeSqrt) + (j * this.size) + (x * this.sizeSqrt) + ((y * this.sizeSqrt) * this.size));
								
								if (cell.value == 0)
								{
								}
								else
								{
									++this.cell [k].invalid [cell.value];
								}
								
								if (value == 0)
								{
								}
								else
								{
									--this.cell [k].invalid [value];
								}
								
								if (j == x)
								{
								}
								else
								{
									l = (i + (row * this.size));
									
									if (cell.value == 0)
									{
									}
									else
									{
										++this.cell [l].invalid [cell.value];
									}
									
									if (value == 0)
									{
									}
									else
									{
										--this.cell [l].invalid [value];
									}
								}
								
								if (j == y)
								{
								}
								else
								{
									m = (column + (i * this.size));
									
									if (cell.value == 0)
									{
									}
									else
									{
										++this.cell [m].invalid [cell.value];
									}
									
									if (value == 0)
									{
									}
									else
									{
										--this.cell [m].invalid [value];
									}
								}
							}
							
							this.data [cell.index] = cell.value;
						}
					}
				}
			}
			
			return this;
		}
		
		public function PutAt (x:int, y:int, value:int) : Board
		{
			return this.Put (this.cell [((y * this.size) + x)], value);
		}
		
		public function Reset () : Board
		{
			var cell:Cell = null;
			
			for each (cell in this.cell)
			{
				if (cell.lock == false)
				{
					this.Put (cell, 0);
				}
			}
			
			return this;
		}
		
		public function Solve () : Board
		{
			var cell:Cell = null;
			
			var data:Vector.<int> = null;
			
			var i:int = 0;
			
			var listOpen:Vector.<Vector.<int>> = null;
			
			data = this.data.slice (0, this.data.length);
			
			if (this.Reset ().Valid () == false)
			{
			}
			else
			{
				listOpen = new Vector.<Vector.<int>> ();
				
				listOpen.push (this.data.slice (0, this.data.length));
				
				for (; ; )
				{
					if (listOpen.length == 0)
					{
						break;
					}
					else
					{
						cell = null;
						
						this.Reset ().Fill (listOpen.pop ());
						
						for (i = 0; i != this.cell.length; ++i)
						{
							if ((this.cell [i].lock == false) && (this.cell [i].value == 0))
							{
								if (cell == null)
								{
									cell = this.cell [i];
									
									this.Available (cell);
								}
								else
								{
									this.Available (this.cell [i]);
									
									if (this.cell [i].available.length < cell.available.length)
									{
										cell = this.cell [i];
									}
								}
							}
						}
						
						for (i = cell.available.length; i != 0; )
						{
							this.Put (cell, cell.available [--i]);
							
							if (this.Valid () == false)
							{
							}
							else
							{
								if (this.Win () == false)
								{
									listOpen.push (this.data.slice (0, this.data.length));
								}
								else
								{
									data = this.data;
									
									listOpen.length = 0;
									
									break;
								}
							}
						}
					}
				}
			}
			
			this.Fill (data);
			
			return this;
		}
		
		public function Valid () : Boolean
		{
			var cell:Cell = null;
			
			var flag:Boolean = true;
			
			for each (cell in this.cell)
			{
				if ((cell.value == 0) && (cell.invalid.indexOf (0, 1) == -1))
				{
					flag = false;
					
					break;
				}
			}
			
			return flag;
		}
		
		public function Win () : Boolean
		{
			var cell:Cell = null;
			
			var flag:Boolean = true;
			
			for each (cell in this.cell)
			{
				if (cell.value == 0)
				{
					flag = false;
					
					break;
				}
			}
			
			return flag;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
