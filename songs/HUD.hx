import flixel.math.FlxRect;

var leftHealth:FlxSprite;
var rightHealth:FlxSprite;
var __healthScale:Float = 0.65;

function postCreate() {
	var leftFillerPath = Paths.image("game/healthbar/filler_right");
	var rightFillerPath = Paths.image("game/healthbar/filler_left");

	if (curSong == "no friendship") {
		leftFillerPath = Paths.image("game/healthbar/filler_beni");
	}

	leftHealth = new FlxSprite(0, -150, leftFillerPath);
	leftHealth.camera = camHUD;
	leftHealth.setGraphicSize(Std.int(leftHealth.width * __healthScale));
	leftHealth.updateHitbox();
	leftHealth.scale.set(1, 1);
	leftHealth.screenCenter();
	leftHealth.y = FlxG.height - leftHealth.height - 46;
	leftHealth.clipRect = new FlxRect(0, 0, leftHealth.frameWidth * 0.5, leftHealth.frameHeight);

	rightHealth = new FlxSprite(0, -150, rightFillerPath);
	rightHealth.camera = camHUD;
	rightHealth.setGraphicSize(Std.int(rightHealth.width * __healthScale));
	rightHealth.updateHitbox();
	rightHealth.scale.set(1, 1);
	rightHealth.onDraw = function(spr:FlxSprite) {
		spr.setPosition(leftHealth.x, leftHealth.y);
		spr.draw();
	};
	rightHealth.clipRect = new FlxRect(0, 0, rightHealth.frameWidth, rightHealth.frameHeight);

	var healthhBarBG = new FlxSprite(0, -150, Paths.image("game/healthbar/Healthbar"));
	healthhBarBG.camera = camHUD;
	healthhBarBG.scale.set(1, 1);
	healthhBarBG.screenCenter();
	healthhBarBG.y = FlxG.height - healthhBarBG.height - 29;
	healthBarBG.visible = false;

	insert(members.indexOf(iconP1), rightHealth);
	insert(members.indexOf(iconP1), leftHealth);
	insert(members.indexOf(iconP1), healthhBarBG);

	if (downscroll) {
		leftHealth.y = FlxG.height - leftHealth.height - 40;
	}
}

function update(elapsed) {
	leftHealth.clipRect = new FlxRect(0, 0, leftHealth.frameWidth * (1 - (health / maxHealth)), leftHealth.frameHeight);
}

function onGamePause(event) {
	event.cancel();

	persistentUpdate = false;
	persistentDraw = true;
	paused = true;

	openSubState(new ModSubState('PauseMenu'));
}

function onGameOver(e) {
	e.cancel();
	persistentUpdate = false;
	persistentDraw = true;
	paused = true;
	openSubState(new ModSubState('BiSide/CustomGameOver'));
	camHUD.visible = false;
}
