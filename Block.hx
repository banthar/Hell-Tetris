
import flash.display.Shape;

class Block extends Shape
{
	
	public var body:phx.Body;
	
	public var speed:phx.Vector;
		
	var color:UInt;
	
	var squares:Array<phx.Vector>;
	
	public function new(x:Float,y:Float,squares:Array<phx.Vector>,color:UInt)
	{
		
		super();
		
		speed=new phx.Vector(0.0,0.0);
		setSpeed(0.0,0.0);
		
		body=new phx.Body(x,y);

		var center=new phx.Vector(0.0,0.0);

		for(t in squares)
		{
			//center.x+=t.x;
			//center.y+=t.y;
		}
	
		center.x/=4.0;
		center.y/=4.0;


		for(t in squares)
		{
			graphics.beginFill(0x000000);
			graphics.drawRect((t.x-center.x)*26-13-2,(t.y-center.y)*26-13-2,26+4,26+4);
			graphics.endFill();
			
			body.addShape(phx.Shape.makeBox(26+4,26+4,(t.x-center.x)*26-13-2,(t.y-center.y)*26-13-2,new phx.Material(0.0,1.0,10.0)));
			
		}
	

		graphics.beginFill(color);
	
		for(t in squares)
		{
			
			graphics.drawRect((t.x-center.x)*26-13,(t.y-center.y)*26-13,26,26);
			
			body.addShape(phx.Shape.makeBox(26,26,(t.x-center.x)*26-13,(t.y-center.y)*26-13));

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
		
		return new Block(x,y,types[type],colors[type]);
		
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
	
}

