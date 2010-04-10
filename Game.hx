
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.geom.ColorTransform;

import flash.events.KeyboardEvent;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


class Game extends Sprite
{
	
	var board:Board;
	
	var text_format:TextFormat;
	var score_label:TextField;
	var top_score_label:TextField;
		
	var top_score:Int;
	var score:Int;
	
	var kongregate:Kongregate;
	
	public function new()
	{
		super();
		
		kongregate=new Kongregate();
		
		top_score=0;
		
		text_format=new TextFormat(flash.text.Font.enumerateFonts()[0].fontName,18);
		
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
		
		score=0;
		
		clear();
		
		board=new Board(this);
		
		board.x=19;
		board.y=18;
		
		addChild(board);
		
		var background=Utils.load("resources.background");
		
		addChild(background);
		
		top_score_label=new TextField();
		top_score_label.defaultTextFormat=text_format;
		top_score_label.autoSize=TextFieldAutoSize.LEFT;
		top_score_label.text="000000";
		top_score_label.embedFonts=true;
		top_score_label.x=295;
		top_score_label.y=202;
		addChild(top_score_label);
		
		score_label=new TextField();
		score_label.defaultTextFormat=text_format;
		score_label.autoSize=TextFieldAutoSize.LEFT;
		score_label.text="000000";
		score_label.embedFonts=true;
		score_label.x=295;
		score_label.y=245;
		addChild(score_label);
		
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
		if(kongregate!=null)
		{
			kongregate.submitStat("lines_cleared",board.lines_cleared);
			kongregate.submitStat("blocks_dropped",board.blocks_dropped);
			kongregate.submitStat("level",board.level);
		}
	
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

	public function updateScore(score:Int)
	{
		
		this.score=score;
		top_score=score>top_score?score:top_score;

		top_score_label.text=""+top_score;
		
		while(top_score_label.text.length<6)
			top_score_label.text="0"+top_score_label.text;
		
		score_label.text=""+score;
		
		while(score_label.text.length<6)
			score_label.text="0"+score_label.text;

	}

}

