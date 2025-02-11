import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;

var optionShit:Array<String> = ["MySide", "LoopingChorus", "NoFriendship", "TogetherAtLast"];
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var confirm:FlxSound;
var usingMouse:Bool = true;
var photoDisplay:FlxSprite; // Sprite pour afficher l'image sélectionnée
var difficultyOptions:Array<String> = ["easy", "normal", "hard"];
var curDifficulty:Int = 1; // Default to "normal"
var difficultyText = new FlxText(0, 500, 0, "Difficulty: Normal", 32);

function create() {
	for (i in 0...optionShit.length) {
		confirm = FlxG.sound.load(Paths.sound('menu/confirm'));
		menuItem = new FunkinSprite(0, 0);
		menuItem.frames = Paths.getSparrowAtlas('menus/freeplay/menubuttons');
		menuItem.animation.addByPrefix('idle', optionShit[i] + 'UnSelected', 8, true);
		menuItem.animation.addByPrefix('hover', optionShit[i] + 'Selected', 8, true);
		menuItem.ID = i;
		menuItems.add(menuItem);
		menuItem.scale.set(1, 1);
		menuItem.antialiasing = true;
		menuItem.alpha = 1;

		var targetX:Int = 0;

		switch (optionShit[i]) {
			case "MySide":
				menuItem.setPosition(-500, 250);
				targetX = 100;
			case "LoopingChorus":
				menuItem.setPosition(-500, 295);
				targetX = 100;
			case "NoFriendship":
				menuItem.setPosition(-500, 340);
				targetX = 100;
			case "TogetherAtLast":
				menuItem.setPosition(-500, 385);
				targetX = 100;
		}

		var delay:Float = i * 0.05;
		FlxTween.tween(menuItem, {x: targetX}, 1, {
			startDelay: delay,
			ease: FlxEase.expoOut
		});
	}

	// Initialiser le sprite pour afficher les images
	photoDisplay = new FlxSprite(FlxG.width - 1200, 100);
	photoDisplay.scale.set(1, 1);
	photoDisplay.antialiasing = true;
	add(photoDisplay);
	photoDisplay.alpha = 0;
	FlxTween.tween(photoDisplay, {alpha: 1}, 1);
	FlxTween.tween(photoDisplay, {x: FlxG.width - 650}, 1, {ease: FlxEase.expoOut});

	trace(optionShit);

	curSelected = 0; // Sélectionne "MySide" par défaut
	lastSelected = -1; // Force l'update au premier affichage
	updateItems(); // Met à jour immédiatement l'affichage

	add(menuItems);

	difficultyText.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	difficultyText.x = 400;
	difficultyText.y = 630;
	add(difficultyText);
	difficultyText.alpha = 0;

	FlxTween.tween(difficultyText, {alpha: 1, x: 650}, 1, {ease: FlxEase.expoOut});
}

function update(elapsed) {
	if (FlxG.mouse.justMoved) {
		usingMouse = true;
	}

	// Change difficulty with LEFT and RIGHT keys
	if (FlxG.keys.justPressed.LEFT) {
		changeDifficulty(-1);
	} else if (FlxG.keys.justPressed.RIGHT) {
		changeDifficulty(1);
	}

	// Handle mouse selection
	if (usingMouse) {
		for (i in menuItems.members) {
			if (FlxG.mouse.overlaps(i)) {
				curSelected = menuItems.members.indexOf(i);
				updateItems();

				if (FlxG.mouse.justPressed) {
					selectItem();
				}
			} else {
				i.animation.play("idle", true);
			}
		}
	}

	// Handle keyboard selection
	if (FlxG.keys.justPressed.UP) {
		changeSelection(-1);
	} else if (FlxG.keys.justPressed.DOWN) {
		changeSelection(1);
	}

	// Confirm selection with ENTER
	if (FlxG.keys.justPressed.ENTER) {
		usingMouse = false;
		selectItem();
	}

	if (controls.BACK) {
		FlxG.resetState();
	}
}

var lastSelected:Int = -1; // -1 signifie qu'aucun élément n'est sélectionné initialement

function updateItems() {
	menuItems.forEach(function(spr:FunkinSprite) {
		if (spr.ID == curSelected) {
			spr.animation.play('hover');

			if (lastSelected != curSelected || lastSelected == -1) {
				lastSelected = curSelected;

				var photoPath:String = switch (optionShit[curSelected]) {
					case "MySide": Paths.image("menus/freeplay/MySidePhotograph");
					case "LoopingChorus": Paths.image("menus/freeplay/LoopingChorusPhotograph");
					case "NoFriendship": Paths.image("menus/freeplay/NoFriendshipPhotograph");
					case "TogetherAtLast": Paths.image("menus/freeplay/TogetherAtLastPhoto");
					default: null;
				};

				if (photoPath != null) {
					photoDisplay.loadGraphic(photoPath);
					photoDisplay.visible = true;
					photoDisplay.updateHitbox();

					var randomRotation:Float = FlxG.random.float(5, -5);
					photoDisplay.angle = randomRotation;

					photoDisplay.scale.set(1.1, 1.1);
					FlxTween.tween(photoDisplay.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.elasticOut});
				} else {
					photoDisplay.visible = false;
				}
			}
		} else {
			spr.animation.play("idle", true);
		}
	});

	// Update difficulty text
	difficultyText.text = "Difficulty: " + difficultyOptions[curDifficulty].toUpperCase();
}

function selectItem() {
	selectedSomethin = true;
	confirm.play();
	updateItems(); // S'assurer que l'image est correcte avant de changer d'état
	switchState();
}

function switchState() {
	var daChoice:String = optionShit[curSelected];
	var selectedDifficulty:String = difficultyOptions[curDifficulty];

	switch (daChoice) {
		case 'MySide':
			PlayState.loadSong("my side", selectedDifficulty);
			FlxG.switchState(new PlayState());
		case 'LoopingChorus':
			PlayState.loadSong("LoopingChorus", selectedDifficulty);
			FlxG.switchState(new PlayState());
		case 'NoFriendship':
			PlayState.loadSong("no friendship", selectedDifficulty);
			FlxG.switchState(new PlayState());
		case 'TogetherAtLast':
			PlayState.loadSong("togetheratlastfr", selectedDifficulty);
			FlxG.switchState(new PlayState());
	}
}

function changeSelection(change:Int = 0, force:Bool = false) {
	if (change == 0 && !force)
		return;

	usingMouse = false;

	curSelected += change;
	if (curSelected >= optionShit.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = optionShit.length - 1;

	updateItems(); // Mise à jour immédiate
}

function changeDifficulty(change:Int) {
	curDifficulty += change;

	if (curDifficulty < 0)
		curDifficulty = difficultyOptions.length - 1;
	if (curDifficulty >= difficultyOptions.length)
		curDifficulty = 0;

	// Update the difficulty text when changing
	difficultyText.text = "Difficulty: " + difficultyOptions[curDifficulty].toUpperCase();

	updateItems();
}
