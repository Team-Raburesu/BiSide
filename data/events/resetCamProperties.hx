import openfl.geom.ColorTransform;

function onEvent(e) {
    if (e.event.name == "resetCamProperties"){
            FlxG.camera.followLerp = 0.04;
            curCameraTarget = e.event.params[0];
            defaultCamZoom = e.event.params[1];
    }
}