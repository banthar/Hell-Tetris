
import flash.display.Shape;

class Block extends Shape
{
	
	public var body:phx.Body;
	
	public var speed:phx.Vector;
		
	public var color:UInt;
	
	public var squares:Array<phx.Vector>;
	
	public function new(x:Float,y:Float,squares:Array<phx.Vector>,color:UInt)
	{
		
		super();
		
		this.color=color;
		this.squares=squares;
		
		speed=new phx.Vector(0.0,0.0);
		setSpeed(0.0,0.0);
		
		body=new phx.Body(x,y);

		for(t in squares)
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(t.x-13-2,t.y-13-2,26+4,26+4);
			graphics.endFill();
			
			body.addShape(phx.Shape.makeBox(26+2,26+2,t.x-13-1,t.y-13-1,new phx.Material(0.0,1.0,10.0)));
		}
	

		graphics.beginFill(color);
	
		for(t in squares)
		{
			graphics.drawRect(t.x-13,t.y-13,26,26);
		}

		graphics.endFill();
		
		updatePosition();
		
	}
	
	public static function randomBlock(x:Float,y:Float)
	{
		var types=[
				[new phx.Vector(-0.5,-0.5),new phx.Vector(-0.5,0.5),new phx.Vector(0.5,-0.5),new phx.Vector(0.5,0.5)],
				[new phx.Vector(0.0,-0.5),new phx.Vector(0.0,0.5),new phx.Vector(0.0,-1.5),new phx.Vector(0.0,1.5)],
				[new phx.Vector(-0.5,-1.0),new phx.Vector(-0.5,0.0),new phx.Vector(-0.5,1.0),new phx.Vector(0.5,1.0)],
				[new phx.Vector(0.5,-1.0),new phx.Vector(0.5,0.0),new phx.Vector(0.5,1.0),new phx.Vector(-0.5,1.0)],
				[new phx.Vector(0.5,-1.0),new phx.Vector(0.5,0.0),new phx.Vector(-0.5,0.0),new phx.Vector(-0.5,1.0)],
				[new phx.Vector(0.5,1.0),new phx.Vector(0.5,0.0),new phx.Vector(-0.5,0.0),new phx.Vector(-0.5,-1.0)],
				[new phx.Vector(-1.0,0.0),new phx.Vector(0.0,0.0),new phx.Vector(0.0,-1.0),new phx.Vector(0.0,1.0)],
			];
		
		var colors=[
				0x1f2487,
				0x8d8d8d,
				0x3b8f22,
				0xb22ea1,
				0x87841f,
				0x1f8781,
				0x942222,
			];
		
		var type=Std.int((types.length)*Math.random());
		
		//type=1;
		
		var squares=[];
		
		for(s in types[type])
		{
			squares.push(s.mult(26.0));
		}
		
		return new Block(x,y,squares,colors[type]);
		
	}
	
	public function tick()
    {
		if(body.island==null || !body.island.sleeping)
		{
			updatePosition();
		}
	}
	
	public function updatePosition()
    {

		x=body.x;
		y=body.y;

        var matrix=new flash.geom.Matrix();
        matrix.rotate(body.a);
        matrix.translate(body.x,body.y);
        transform.matrix=matrix;
    }
	
	public function rotate(radians:Float)
	{
		body.a+=radians;
				
		updatePosition();
	
		var bounds=getBounds(parent);
	
		if(bounds.x < 0)
			body.x-=getBounds(parent).x;

		if(bounds.x+bounds.width > 260)
			body.x-=bounds.x+bounds.width-260;
	
	}
	
	public function setSpeed(?x:Float,?y:Float)
	{
		
		var s=100.0;
		
		if(x!=null)
		{
			//body.v.x-=speed.x;
			speed.x=x*s;
			//body.v.x=speed.x;
		}
		
		if(y!=null)
		{
			//body.v.y-=speed.y;
			speed.y=(y*2.0+0.5)*s;
			//body.v.y=speed.y;
		}
	}
	
	public function updateStructure():Array<Block>
	{
		
		var new_blocks=[];
		
		var new_squares=null;
		
		squares.push(null);
		
		for(s in squares)
		{
			
			if(s==null)
			{
				
				if(new_squares!=null)
				{
					var block=new Block(body.x,body.y,new_squares,color);
					block.body.a=body.a;
					
					new_blocks.push(block);
					
					new_squares=null;
				}
				
			}
			else
			{
				
				if(new_squares==null)
					new_squares=[];
				
				new_squares.push(s);

			}
			
		}
		
		return new_blocks;
		
	}
	
	public function removeSquare(square:phx.Vector)
	{

		for(i in 0...squares.length)
		{
			if(squares[i] == square)
			{
				squares[i]=null;
				return;
			}
		}
		
		throw "no such square";
		
	}
	
}

