import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;

function create() {
	credit = new FlxSprite(600, 60).loadGraphic(Paths.image('menus/credits'));
	add(credit);
	credit.scale.set(0.2, 0.2);

	FlxTween.tween(credit, {x: FlxG.width / 2 - credit.width / 2, y: FlxG.height / 2 - credit.height / 2}, 1, {ease: FlxEase.expoOut});
	FlxTween.tween(credit.scale, {x: 1, y: 1}, 1, {ease: FlxEase.expoOut, onUpdate:
		function(twn:FlxTween)
		{
			credit.updateHitbox();
		}
	});
}

function update(elapsed) {
	if (controls.BACK) {
		FlxG.resetState();
	}
}
