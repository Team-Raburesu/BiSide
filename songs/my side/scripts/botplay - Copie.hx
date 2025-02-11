import flixel.math.FlxRect;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;

var leftHealth:FlxSprite;
var rightHealth:FlxSprite;
var __healthScale:Float = 0.65;
var comboText:FlxText; // Texte affichant le combo

function postCreate() {
	var leftFillerPath = Paths.image("stages/tini/filler");
	var rightFillerPath = Paths.image("stages/tini/right");
	var uibar = Paths.image("stages/tini/UpscrollPhoneGameUI");
	if (downscroll) {
		uibar = Paths.image("stages/tini/DownscrollPhoneGameUI");
	}

	healthBar.visible = false;
	healthBarBG.visible = false;
	iconP1.visible = false;
	iconP2.visible = false;

	ui = new FlxSprite(0, 0, uibar);
	ui.scrollFactor.set(0, 0);
	ui.cameras = [camHUD];
	ui.scale.set(0.975, 0.975);
	ui.antialiasing = true;

	// Positionner la barre de vie à gauche
	leftHealth = new FlxSprite(240, -150, leftFillerPath); // Déplace vers la gauche
	leftHealth.camera = camHUD;
	leftHealth.setGraphicSize(Std.int(leftHealth.width * __healthScale));
	leftHealth.updateHitbox();
	leftHealth.scale.set(0.58, 0.58);
	leftHealth.y = FlxG.height - leftHealth.height - 135;
	leftHealth.clipRect = new FlxRect(0, 0, leftHealth.frameWidth * 0.5, leftHealth.frameHeight);

	rightHealth = new FlxSprite(leftHealth.x + leftHealth.width + 5, leftHealth.y, rightFillerPath); // Aligné à gauche
	rightHealth.camera = camHUD;
	rightHealth.setGraphicSize(Std.int(rightHealth.width * __healthScale));
	rightHealth.updateHitbox();
	rightHealth.scale.set(0.58, 0.58);
	rightHealth.onDraw = function(spr:FlxSprite) {
		spr.setPosition(leftHealth.x, leftHealth.y);
		spr.draw();
	};
	rightHealth.clipRect = new FlxRect(0, 0, rightHealth.frameWidth, rightHealth.frameHeight);

	// Ajout dans le bon ordre
	comboText = new FlxText(90, 0, 0, "Combo: 0", 32);
	comboText.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER);

	comboText.x = 96;
	comboText.y = 503;
	comboText.cameras = [camHUD];

	if (downscroll) {
		comboText.y = 492;
		leftHealth.y = FlxG.height - leftHealth.height - 75;
	}

	insert(members.indexOf(iconP1), ui);
	insert(members.indexOf(iconP1), rightHealth);
	insert(members.indexOf(iconP1), leftHealth);
	insert(members.indexOf(iconP1), comboText);
}

function update(elapsed) {
	leftHealth.clipRect = new FlxRect(0, 0, leftHealth.frameWidth * (1 - (health / maxHealth)), leftHealth.frameHeight);
	trace(combo);
	comboText.text = combo;

	if (combo > 9) {
		comboText.x = 90;
	}

	if (combo < 10) {
		comboText.x = 96;
	}
}
if (combo > 99) {
	comboText.x = 86;
}
