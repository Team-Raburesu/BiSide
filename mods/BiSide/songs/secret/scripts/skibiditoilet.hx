function onCountdown(event)
	event.cancel();

function postCreate() {
	var blackbar = new FlxSprite(0, 0).makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
	blackbar.cameras = [camHUD];
	add(blackbar);
	FlxTween.tween(blackbar, {alpha: 0}, 4, {ease: FlxEase.quadInOut});
}
