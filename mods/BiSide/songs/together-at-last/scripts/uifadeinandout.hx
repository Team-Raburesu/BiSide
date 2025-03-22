function stepHit(curStep:Int) {
    if (curStep == 385) {
        FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quartOut});
    } else if (curStep == 410) {
        FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.quartIn});
    }
}y