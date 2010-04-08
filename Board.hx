
import flash.events.KeyboardEvent;

import flash.display.Sprite;

class Board extends Sprite
{
	
	public var w:Float;
	public var h:Float;
	
	public var world : phx.World;
	
	public var blocks:Array<Block>;
	
	public var current_block:Block;
	
	public var next_block:Block;
	
	private var time_to_next_block:Float;
	
	private var game:Game;

	private var borders:Array<phx.Polygon>;
	
	public var blocks_dropped:Int;
	
	public function new(game:Game)
	{

		super();

		this.game=game;
		blocks_dropped=0;

		w=260;
		h=410;

		blocks=[];

		world = new phx.World(new phx.col.AABB(-10,-10,w+10,h+10),new phx.col.SortedList());
		//world.sleepEpsilon=1/20;
		world.gravity = new phx.Vector(0,2.0);

		world.addStaticShape(phx.Shape.makeBox(w,10,0,-110));
		world.addStaticShape(phx.Shape.makeBox(w,10,0,h));
		
		borders=[phx.Shape.makeBox(10,h+100,-10,-100),phx.Shape.makeBox(10,h+100,w,-100)];
		
		world.addStaticShape(borders[0]);
		world.addStaticShape(borders[1]);

		var c=50;

		for(x in 0...c)
		{
			
			//var y=w/2.0;
			
			var t=(x-1.0/c+0.6)/c*2.0-1.0;
			
			var y=(1.0-Math.sqrt(1-t*t))*w/2.0;
			
			world.addStaticShape(phx.Shape.makeBox(w/c,y,x/c*w-w/c/2.0,h-y));
			
		}

		addEventListener(flash.events.Event.ENTER_FRAME,tick);

		Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		Main.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);

		addBlock();

	}
	
	private function onKeyDown(e:KeyboardEvent)
	{
		
		if(current_block==null)
			return;
		
		switch(e.keyCode)
		{
			case 37:
				current_block.setSpeed(-1.0,null);
			case 38:
				current_block.body.a+=Math.PI/2.0;
			case 39:
				current_block.setSpeed(1.0,null);
			case 40:
				current_block.setSpeed(null,1.0);
			default:
				trace(e.keyCode);
		}
	}
	
	private function onKeyUp(e:KeyboardEvent)
	{
		
		if(current_block==null)
			return;
		
		switch(e.keyCode)
		{
			case 37:
				current_block.setSpeed(0.0,null);
			case 39:
				current_block.setSpeed(0.0,null);
			case 40:
				current_block.setSpeed(null,0.0);
			default:
				trace(e.keyCode);
		}
	}	
	
	private function addBlock()
	{
		
		if(next_block==null)
			next_block=new Block(w/2.0,-10.0);
		else
			removeChild(next_block);
		
		if(current_block!=null)
			throw "Illegal state";
		
		current_block=next_block;
		
		world.addBody(current_block.body);
		
		blocks.push(current_block);
		addChild(current_block);
		
		next_block=new Block(w/2.0,-10.0);

		var bounds=next_block.getBounds(next_block);

		next_block.x=325-bounds.width/2.0-bounds.x;
		next_block.y=87-bounds.height/2.0-bounds.y;
		
		addChild(next_block);
		
	}
	
	private function tick(?_)
	{
		
		world.step(1.0/30.0*4.0,10);
		
		if(time_to_next_block>0)
		{
			time_to_next_block-=1.0/30.0;
			
			if(time_to_next_block<0)
			{
				addBlock();
			}
			
		}
		
		graphics.clear();
		
		/*
		var fd = new phx.FlashDraw(graphics);
        fd.drawCircleRotation = true;
        fd.drawWorld(world);
		*/
		
		for(block in blocks)
		{
			block.tick();
		}
		
		if(current_block!=null && !current_block.body.arbiters.isEmpty())
		{


			var go=false;
			
			for(arbiter in current_block.body.arbiters)
			{
				
				var shape = if(arbiter.s1.body == current_block.body) arbiter.s2 else arbiter.s1;
				
				if(shape != borders[0] && shape != borders[1])
					go=true;
			}

			if(go)
			{

				if(current_block.y>0.0)
				{
					time_to_next_block=1.0;
					blocks_dropped++;
				}
				else
				{
					game.gameOver();
				}

				current_block=null;
			}
		
		}
		
	}
	
	public function destroy()
	{
		removeEventListener(flash.events.Event.ENTER_FRAME,tick);
		Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		Main.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
	}
	
}

