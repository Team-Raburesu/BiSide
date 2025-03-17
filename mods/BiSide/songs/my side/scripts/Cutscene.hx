import funkin.backend.scripting.events.DrawEvent;
import hxvlc.flixel.FlxVideoSprite;

var cutscene = new FlxVideoSprite(0, 0);

function postCreate() {
	cutscene.bitmap.onFormatSetup.add(function() {
		cutscene.alpha = 1;
	});
	cutscene.load(Assets.getPath(Paths.video("MysideConceptWip")));
	add(cutscene);
	cutscene.play();
	cutscene.cameras = [camHUD];
	if (FlxG.signals.focusGained.has(cutscene.resume)) {
		FlxG.signals.focusGained.remove(cutscene.resume);
	}
}

function onGamePause() {
	cutscene.pause();
}

function onSubstateClose() {
	if (paused) {
		cutscene.resume();
	}
}

function onFocus() {
	if (!paused) {
		cutscene.resume();
	}
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 220:
			FlxTween.tween(cutscene, {alpha: 0}, 1); // change of when it finish
	}
}

function onGameOver(e) {
	cutscene.remove();
	cutscene.pause();
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.R) {
		cutscene.remove();
		cutscene.pause();
	}
}

function postUpdate(elapsed:Float) {
	if (FlxG.keys.justPressed.R) {
		cutscene.remove();
		cutscene.pause();
	}
}
