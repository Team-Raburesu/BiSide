function postCreate() {
	benicutscene = new FunkinSprite(0, 0, Paths.image("stages/beni/Benicutscene"));
	XMLUtil.addAnimToSprite(benicutscene, {
		name: "spritemap1",
		anim: "beni sequence",
		fps: 24,
		loop: true,
		animType: "", // if you use "loop" then it automatically plays the last added animation
		x: 1940, // offsetX
		y: -750, // offsetY
		indices: [],
		forced: false, // If everytime the animation plays, it should be forced to play
	});
	benicutscene.playAnim("spritemap1", false);
	insert(2, benicutscene);
	benicutscene.scale.set(0.7, 0.7);
	boyfriend.alpha = 0;
dad.alpha = 0;
	if (FlxG.signals.focusGained.has(benicutscene.resume)) {
		FlxG.signals.focusGained.remove(benicutscene.resume);
	}

	
}

function onGamePause() {
	benicutscene.pause();
	gfcutscene.pause();
}

function onSubstateClose() {
	if (paused) {
		benicutscene.resume();
		gfcutscene.resume();
	}
}

function onFocus() {
	if (!paused) {
		benicutscene.resume();
		gfcutscene.resume();
	}
}

function stepHit(curStep:Int) {
	switch (curStep) {

		case -10: gfcutscene = new FunkinSprite(746, 734, Paths.image("stages/beni/ANAYA_POP"));
	XMLUtil.addAnimToSprite(benicutscene, {
		name: "spritemap1",
		anim: "anaya sequence",
		fps: 24,
		loop: true,
		animType: "", // if you use "loop" then it automatically plays the last added animation
		x: 1940, // offsetX
		y: -750, // offsetY
		indices: [],
		forced: false, // If everytime the animation plays, it should be forced to play
	});
	gfcutscene.playAnim("spritemap1", false);
	insert(2, gfcutscene);
	gfcutscene.scale.set(0.72, 0.72);


	if (FlxG.signals.focusGained.has(gfcutscene.resume)) {
		FlxG.signals.focusGained.remove(gfcutscene.resume);
	}
		case 60:
			dad.alpha = 1;
			remove(benicutscene, true);

			case 68: 			
			FlxTween.tween(boyfriend, {alpha:1}, 0.2, {ease: FlxEase.quadInOut});

			case 70: FlxTweeneen.tween(gfcutscene, {alpha:0}, 0.2, {ease: FlxEase.quadInOut});

			case 72: remove(gfcutscene, true);
	}
}
