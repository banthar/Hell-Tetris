
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.geom.ColorTransform;

import flash.events.KeyboardEvent;

class Game extends Sprite
{
	
	var board:Board;
	
	public function new()
	{
		super();
		
		newGame();
		gameOver();
		
		Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		
	}
	
	public function onKeyDown(e:KeyboardEvent)
	{
		
		if(e.keyCode==32 && board==null)
			newGame();
	}
	
	public function newGame()
	{
		
		clear();
		
		board=new Board(this);
		
		board.x=19;
		board.y=18;
		
		addChild(board);
		
		var background=Utils.load("resources.background");
		
		addChild(background);
		
	}
	
	public function clear()
	{
		while(numChildren > 0)
		{
			removeChildAt(0);
		}
	}
	
	public function gameOver()
	{
		trace("game over");
		
		var bitmapData=new BitmapData(Std.int(width),Std.int(height));
		
		bitmapData.draw(this);
		
		bitmapData.colorTransform(bitmapData.rect, new ColorTransform(0.125,0.125,0.125,1.0,192,192,192));
		
		clear();
		
		board.destroy();
		board=null;
		
		addChild(new Bitmap(bitmapData));
		
		var label=Utils.load("resources.press_to_play");
		
		label.x=(width-label.width)/2;
		label.y=(height-label.height)/2;
		
		addChild(label);
		
	}
}

