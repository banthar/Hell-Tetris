
import flash.display.DisplayObject;

class Utils
{
	public static function load(name:String):DisplayObject
	{

		var c=Type.resolveClass(name);
		
		if(c==null)
			return null;
		else
			return Type.createInstance(c,[]);
		
	}
}

