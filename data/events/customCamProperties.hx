import openfl.geom.ColorTransform;

var awesomeCore = false;

function onEvent(e) {
    if (e.event.name == "customCamProperties") {
        trace(camGame.scroll.y);
        var hi = e;
        //e.event.params[0]
        //(Conductor.stepCrochet / 1000) * event.params[2]
        var output3 = e.event.params[3];
        var output4 = e.event.params[4];
        var output5 = e.event.params[5];
        var flxease:String = (e.event.params[0]) + (e.event.params[1]);
        if (e.event.params[3] == (-1)) {
            output3 = camGame.scroll.x;
        }
        else if (e.event.params[6] == true) {
            output3 = camGame.scroll.x + e.event.params[3];
        }
        else {
            output3 = e.event.params[3];
        }
        if (e.event.params[4] == (-1)) {
            output4 = camGame.scroll.y;
        }
        else if (e.event.params[6] == true) {
            output4 = camGame.scroll.y + e.event.params[4];
        }
        else {
            output4 = e.event.params[4];
        }
        if (e.event.params[5] == (-1)) {
            output5 = defaultCamZoom;
        }
        else if (e.event.params[6] == true) {
            output5 = defaultCamZoom + e.event.params[5];
        }
        else {
            output5 = e.event.params[5];
        }
        trace(camGame.scroll.y);
        trace(output4);
        FlxTween.tween(camGame, {"scroll.x": output3, "scroll.y": output4, zoom: output5}, e.event.params[2] * (Conductor.stepCrochet / 1000), {ease: Reflect.field(FlxEase, flxease)});
        FlxG.camera.followLerp = 0;
        awesomeCore = true;
        new FlxTimer().start(e.event.params[2] * (Conductor.stepCrochet / 1000), function(timer) {
            awesomeCore = false;
            if (hi.event.params[8] == true) {
                FlxG.camera.followLerp = hi.event.params[7];
            }
        });	
    }
}

function update() {
    if (awesomeCore == true) {
        defaultCamZoom = FlxG.camera.zoom;
    }
}