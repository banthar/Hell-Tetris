
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
	public var lines_cleared:Int;
	
	public var level:Int;
	
	public function new(game:Game)
	{

		super();

		this.game=game;
		blocks_dropped=0;
		lines_cleared=0;
		level=1;
		
		time_to_next_block=0.0;
		
		w=260;
		h=410;

		blocks=[];

		world = new phx.World(new phx.col.AABB(-100,-100,w+10,h+10),new phx.col.SortedList());
		//world.sleepEpsilon=1/20;
		world.gravity = new phx.Vector(0,100.0);

		//world.addStaticShape(phx.Shape.makeBox(w,10,0,-200));
		world.addStaticShape(phx.Shape.makeBox(w,10,0,h));
		
		borders=[phx.Shape.makeBox(10,h+100,-10,-100),phx.Shape.makeBox(10,h+100,w,-100)];
		
		world.addStaticShape(borders[0]);
		world.addStaticShape(borders[1]);

		var c=50;

		for(x in 0...c)
		{
			
			//var y=w/2.0;
			
			var t=(x-1.0/c+0.6)/c*2.0-1.0;

#if DEBUG			
			t=1.0;
#end
			
			var y=(1.0-Math.sqrt(1-t*t))*w/2.0;
			
			world.addStaticShape(phx.Shape.makeBox(w/c,y,x/c*w-w/c/2.0,h-y,new phx.Material(0.0,1.0,0.0)));
			
		}

		addEventListener(flash.events.Event.ENTER_FRAME,tick);

		Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		Main.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);

		newBlock();

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
				current_block.rotate(Math.PI/2.0);
			case 39:
				current_block.setSpeed(1.0,null);
			case 40:
				current_block.setSpeed(null,1.0);
			default:
				//trace(e.keyCode);
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
				//trace(e.keyCode);
		}
	}	
	
	private function addBlock(block:Block)
	{
		
		world.addBody(block.body);
		
		blocks.push(block);
		addChild(block);
		
	}
	
	private function removeBlock(block:Block)
	{
		world.removeBody(block.body);
		blocks.remove(block);
		removeChild(block);
	}
	
	private function newBlock()
	{
		
		if(next_block==null)
			next_block=Block.randomBlock(w/2.0,2.5*-26.0);
		else
			removeChild(next_block);
		
		if(current_block!=null)
			throw "Illegal state";
		
		current_block=next_block;
		
		addBlock(current_block);
		
		next_block=Block.randomBlock(w/2.0,2.5*-26.0);

		var bounds=next_block.getBounds(next_block);

		next_block.x=325-bounds.width/2.0-bounds.x;
		next_block.y=87-bounds.height/2.0-bounds.y;
		
		addChild(next_block);
		
	}
	
	private function tick(?_)
	{
		
		world.step(1.0/30.0,10);
		
		if(time_to_next_block>0)
		{
			time_to_next_block-=1.0/30.0;
			
			if(time_to_next_block<0)
			{
				if(current_block==null)
				{
					newBlock();
				}
				else
				{
					blocks_dropped++;
					current_block=null;
					time_to_next_block=1.0;
				}
				
			}
			
		}
		
#if DEBUG		
		graphics.clear();
		var fd = new phx.FlashDraw(graphics);
        fd.drawCircleRotation = true;
        fd.drawWorld(world);
#end		
	
		for(block in blocks)
		{
			block.tick();
		}
		
		if(current_block==null)
		{
			while(checkAndClear())
			{
			}
		}
		
		if(current_block!=null)
		{
			current_block.body.v.set(current_block.speed.x,current_block.speed.y);
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

			if(go && time_to_next_block<=0.0)
			{

				if(current_block.y>0.0)
				{
					time_to_next_block=0.5;
				}
				else
				{
					game.gameOver();
					current_block=null;
				}

				
			}
		
		}
		
	}
	
	private function checkAndClear():Bool
	{

		var boxes:Array<Box>=[];
		
		for(block in blocks)
		{
								
			var body=block.body;
			
			var a=body.a*2.0/Math.PI;
			
			//block.alpha=(Math.abs(a-Math.round(a))<0.1)?1.0:0.5;
			
			if(Math.abs(a-Math.round(a))<0.1)
			{
				
				for(s in block.squares)
				{
					
					var y=s.y*body.rsin+body.y;
					
					boxes.push(new Box(block,s));

				}
			}
			
		}
	
		boxes.sort(Box.compareY);
	
		for(i in 8...boxes.length)
		{
			if(boxes[i].y-boxes[i-8].y<15)
			{
				
				trace("score: "+(i-8)+"  "+i);
				
				for(j in i-8...(i+1))
				{
					boxes[j].block.removeSquare(boxes[j].square);
				}
				
				for(j in i-8...(i+1))
				{
					
					if(boxes[j].block.parent!=null)
					{
					
						for(b in boxes[j].block.updateStructure())
						{
							addBlock(b);
						}
						
						removeBlock(boxes[j].block);
					}
				
				}
				
				lines_cleared++;
				
				game.updateScore(lines_cleared);
				
				return true;
				
			}
		}
		
		return false;
		
	}
	
	public function destroy()
	{
		removeEventListener(flash.events.Event.ENTER_FRAME,tick);
		Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		Main.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
	}
	
}

