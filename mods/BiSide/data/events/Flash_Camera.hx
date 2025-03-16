var color:FlxColor;

function flash(col:FlxColor, dur:Int, initialAlpha:Float)
{


    var flash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, col);
    flash.blend = 0;
    flash.screenCenter();
    add(flash);
    
    
}

function onEvent(e:EventGameEvent)
{
    if (e.event.name == "Flash Camera")
    {
        var initialAlpha:Float;
        color = switch(e.event.params[1]){
            case 'Black': initialAlpha = 1; FlxColor.BLACK;
            case 'White': initialAlpha = 0.8; FlxColor.WHITE; 
        };
        flash(color, e.event.params[0], initialAlpha);
    }
}
