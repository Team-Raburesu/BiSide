import funkin.backend.scripting.events.DrawEvent;
import hxvlc.flixel.FlxVideoSprite;

var cutscene = new FlxVideoSprite(0, 0);

function onCountdown(event)
	event.cancel();


function create() {

	cutscene.bitmap.onFormatSetup.add(function() {
		cutscene.alpha = 1;
		cutscene.volume = 100;
	});
	cutscene.load(Assets.getPath(Paths.video("togetheratlastfr")));
	insert(1200, cutscene);
	cutscene.play();
	cutscene.cameras = [camHUD];
	if (FlxG.signals.focusGained.has(cutscene.resume)) {
		FlxG.signals.focusGained.remove(cutscene.resume);
	}
	camZoomingInterval = 999;
	
function postcreate(){

	healthBarBG.visible = false;
healthbar.visible = false;
iconP2.visible = false;
iconP1.visible = false; }

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
		case 80:
			FlxTween.tween(cutscene, {alpha: 0}, 1); // change of when it finish
			camZoomingInterval = 2;
	}
}
