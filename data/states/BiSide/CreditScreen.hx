import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;

function create() {
	credit = new FlxSprite(600, 60).loadGraphic(Paths.image('menus/credits/Credits'));
	add(credit);
	credit.scale.set(0.2, 0.2);

	FlxTween.tween(credit, {x: 50}, 1, {ease: FlxEase.expoOut});
	FlxTween.tween(credit.scale, {x: 1, y: 1}, 1, {ease: FlxEase.expoOut});
}

function update(elapsed) {
	if (controls.BACK) {
		FlxG.resetState();
	}
}
