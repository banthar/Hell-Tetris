class Kongregate 
{
    var kongregate:Dynamic;

    public function new()
    {
        kongregate = null;
            
        var parameters = flash.Lib.current.loaderInfo.parameters;

        var url: String;
        
        url = parameters.api_path;
        
        if(url == null)
            url = "http://www.kongregate.com/flash/API_AS3_Local.swf";
        
        var request = new flash.net.URLRequest(url);             
        
        var loader = new flash.display.Loader();
        loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadComplete);
        loader.load(request);

        flash.Lib.current.addChild(loader);
    }

    function onLoadComplete(e: flash.events.Event)
    {
        try
        {
			trace("kongregate initialised");
			
            kongregate = e.target.content;
            kongregate.services.connect();
        }
        catch(msg: Dynamic)
        {
			
			trace(msg);
			
            kongregate = null;
        }
    }

    public function submitStat(name: String, stat: Float)
    {
        if(kongregate != null)
        {
            kongregate.stats.submit(name, stat);
        }
    }

}
