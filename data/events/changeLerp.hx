import openfl.geom.ColorTransform;

function onEvent(e) {
    if (e.event.name == "changeLerp"){
        FlxG.camera.followLerp = e.event.params[0];
    }
}