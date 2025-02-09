import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

var bf:Character;
var deathSound:FlxSound;
var gameOverMusic:FlxSound;
var deathend:FlxSound;
var canPress:Bool = false;
var isEnding:Bool = false;
var camGameOver:FlxCamera;

function create() {
	FlxG.state.persistentUpdate = false;
	FlxG.state.persistentDraw = true;
	FlxG.state.paused = true;

	camGameOver = new FlxCamera();
	camGameOver.bgColor = 0x00000000;
	FlxG.cameras.add(camGameOver, false);
	camGameOver.alpha = 1;
	camGameOver.zoom = 0.8;

	var blackBG = new FlxSprite().makeGraphic(FlxG.width + 500, FlxG.height + 500, 0xFF000000);
	blackBG.scrollFactor.set();
	blackBG.alpha = 0;
	blackBG.screenCenter();
	blackBG.cameras = [camGameOver];
	add(blackBG);
	FlxTween.tween(blackBG, {alpha: 0.5}, 0.4, {ease: FlxEase.quadOut});

	bf = new Character(400, -200, "BFDEATH");
	add(bf);
	bf.scrollFactor.set(0, 0);
	bf.scale.set(0.8, 0.8);
	bf.alpha = 0;
	bf.cameras = [camGameOver];
	FlxTween.tween(bf, {y: bf.y - 100, alpha: 1}, 0.4, {ease: FlxEase.quadOut});
	bf.playAnim("firstDeath");

	deathSound = new FlxSound().loadEmbedded(Paths.sound("gameOverSFX"));
	deathSound.play();

	new FlxTimer().start(1.8, function() {
		bf.playAnim("deathLoop", true);
		canPress = true;

		gameOverMusic = new FlxSound().loadEmbedded(Paths.music("gameOver"), true);
		gameOverMusic.volume = 0.8;
		gameOverMusic.play();
		FlxG.sound.list.add(gameOverMusic);
	});
}

function update(elapsed) {
	if (canPress && FlxG.keys.justPressed.ENTER && !isEnding) {
		isEnding = true;
		canPress = false;
		bf.playAnim("deathConfirm");

		stopGameOverMusic();

		deathend = new FlxSound().loadEmbedded(Paths.sound("gameOverEnd"));
		deathend.play();
		FlxTween.tween(bf, {y: bf.y - 100, x: bf.x - 20}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(bf.scale, {x: 0.7, y: 0.7}, 2, {ease: FlxEase.quadOut});

		new FlxTimer().start(1.8, function() {
			PlayState.instance.registerSmoothTransition();
			FlxG.resetState();
		});
	}

	if (canPress && controls.BACK && !isEnding) {
		isEnding = true;
		canPress = false;
		bf.playAnim("drop");

		stopGameOverMusic();

		deathend = new FlxSound().loadEmbedded(Paths.sound("gameOverEnd"));
		deathend.play();

		new FlxTimer().start(1, function() {
			FlxG.switchState(new MainMenuState());
		});
	}
}

function stopGameOverMusic() {
	if (gameOverMusic != null) {
		gameOverMusic.stop();
		FlxG.sound.list.remove(gameOverMusic);
		gameOverMusic.destroy();
		gameOverMusic = null;
	}
}

function destroy() {
	stopGameOverMusic();
	super.destroy();
}
