
class Box
{
	public var y:Float;
	public var block:Block;
	public var square:phx.Vector;
	
	public function new(block:Block,square:phx.Vector)
	{
		this.block=block;
		this.square=square;
		
		this.y=square.x*block.body.rsin+square.y*block.body.rcos+block.body.y;
	}

	public static function compareY(a:Box,b:Box):Int
	{
		if(a.y==b.y)
			return 0;
		else if(a.y>b.y)
			return 1;
		else
			return -1;
	}
	
	public function toString():String
	{
		return y+"";
	}
	
}

