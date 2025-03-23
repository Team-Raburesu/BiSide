import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;

var optionShit:Array<String> = ["my-side", "looping-chorus", "no-friendship", "together-at-last"];
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var confirm:FlxSound;
var usingMouse:Bool = true;
var photoDisplay:FlxSprite; // Sprite pour afficher l'image sélectionnée
var difficultyOptions:Array<String> = ["easy", "normal", "hard"];
var curDifficulty:Int = 1; // Default to "normal"
var difficultyText = new FlxText(0, 500, 0, "Difficulty: Normal", 32);

var leftArrow:FlxSprite;
var rightArrow:FlxSprite;

var mouseTrackerX:Float = 0;
var mouseTrackerY:Float = 0;

var selSmth:Bool = false;

function create() {
	for (i in 0...optionShit.length) {
		confirm = FlxG.sound.load(Paths.sound('menu/confirm'));
		menuItem = new FunkinSprite(0, 250);
		menuItem.frames = Paths.getSparrowAtlas('menus/freeplay/menubuttons');
		menuItem.animation.addByPrefix('idle', optionShit[i] + '-UnSelected', 8, true);
		menuItem.animation.addByPrefix('hover', optionShit[i] + '-Selected', 8, true);
		menuItem.ID = i;
		menuItems.add(menuItem);
		menuItem.antialiasing = true;
		menuItem.alpha = 1;

		menuItem.x = -500;
		menuItem.y += menuItem.height + 45 * i;

		var delay:Float = i * 0.05;
		FlxTween.tween(menuItem, {x: 100}, 1, {
			startDelay: delay,
			ease: FlxEase.expoOut
		});
	}

	photoDisplay = new FlxSprite(FlxG.width - 1200, 70);
	photoDisplay.scale.set(1, 1);
	photoDisplay.antialiasing = true;
	add(photoDisplay);
	photoDisplay.alpha = 0;
	FlxTween.tween(photoDisplay, {alpha: 1}, 1);
	FlxTween.tween(photoDisplay, {x: FlxG.width - 650}, 1, {ease: FlxEase.expoOut});

	curSelected = 0; 
	lastSelected = -1;

	add(menuItems);

	difficultyText.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	difficultyText.x = 650; // Center the text
	difficultyText.y = 620;
	add(difficultyText);
	difficultyText.alpha = 0;

	leftArrow = new FlxSprite(550, difficultyText.y - 10);
	leftArrow.frames = Paths.getSparrowAtlas('menus/arrow_LEFT');
	leftArrow.animation.addByPrefix('press', 'pressed', 1, false);
	leftArrow.animation.addByPrefix('nopress', 'unpressed', 1, false);
	leftArrow.scale.set(0.1, 0.1);
	leftArrow.updateHitbox();
	leftArrow.antialiasing = true;
	leftArrow.animation.play('nopress');
	add(leftArrow);
	leftArrow.alpha = 0;

	rightArrow = new FlxSprite(1140, difficultyText.y - 10);
	rightArrow.frames = Paths.getSparrowAtlas('menus/arrow_RIGHT');
	rightArrow.animation.addByPrefix('press', 'pressed', 1, false);
	rightArrow.animation.addByPrefix('nopress', 'unpressed', 1, false);
	rightArrow.scale.set(0.1, 0.1);
	rightArrow.updateHitbox();
	rightArrow.antialiasing = true;
	rightArrow.animation.play('nopress');
	add(rightArrow);
	rightArrow.alpha = 0;

	FlxTween.tween(difficultyText, {alpha: 1}, 1, {ease: FlxEase.expoOut});
	FlxTween.tween(leftArrow, {alpha: 1}, 1, {ease: FlxEase.expoOut});
	FlxTween.tween(rightArrow, {alpha: 1}, 1, {ease: FlxEase.expoOut});
}

function update(elapsed) {
	updateItems();
	if (!selSmth)
	{
		if (FlxG.keys.justPressed.ENTER) {
			selectItem();
		}
	
		if (controls.BACK) {
			FlxTween.tween(photoDisplay, {x: 930, alpha: 0}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(difficultyText, {alpha: 0, x: 950}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(leftArrow, {alpha: 0, x: 850}, 0.5, {ease: FlxEase.expoOut});
			for (item in menuItems.members)
			{
				FlxTween.tween(item, {alpha: 0, x: 400}, 0.5, {ease: FlxEase.expoOut});			
			}
			FlxTween.tween(rightArrow, {alpha: 0, x: 1440}, 0.5, {ease: FlxEase.expoOut, onComplete: function(twn:FlxTween)
				{
					close();
				}
			});
		}

		if (FlxG.keys.justPressed.LEFT) {
			usingMouse = false;
			mouseTrackerX = FlxG.mouse.x;
			mouseTrackerY = FlxG.mouse.y;
			changeDifficulty(-1);
		} else if (FlxG.keys.justPressed.RIGHT) {
			usingMouse = false;
			mouseTrackerX = FlxG.mouse.x;
			mouseTrackerY = FlxG.mouse.y;
			changeDifficulty(1);
		}

		if (FlxG.keys.justPressed.UP) {
			usingMouse = false;
			mouseTrackerX = FlxG.mouse.x;
			mouseTrackerY = FlxG.mouse.y;
			changeSelection(-1);
		} else if (FlxG.keys.justPressed.DOWN) {
			usingMouse = false;
			mouseTrackerX = FlxG.mouse.x;
			mouseTrackerY = FlxG.mouse.y;
			changeSelection(1);
		}

		if (usingMouse) {
			for (i in menuItems.members) {
				if (FlxG.mouse.overlaps(i) && usingMouse) {
					curSelected = menuItems.members.indexOf(i);
					if (FlxG.mouse.justPressed) {
						selectItem();
					}
				}
			}
	
			if (FlxG.mouse.overlaps(leftArrow) || FlxG.mouse.overlaps(rightArrow))
			{
				if (FlxG.mouse.overlaps(leftArrow)) {
					leftArrow.animation.play('press');
					if (FlxG.mouse.justPressed) changeDifficulty(-1);
				} 
				else if (FlxG.mouse.overlaps(rightArrow)) {
					rightArrow.animation.play('press');
					if (FlxG.mouse.justPressed) changeDifficulty(1);
				}
			}
			else
			{
				leftArrow.animation.play('nopress');
				rightArrow.animation.play('nopress');
			}
		}
	}
	
	if (FlxG.mouse.x != mouseTrackerX && FlxG.mouse.y != mouseTrackerY){
        usingMouse = true;
    }
}

var lastSelected:Int = -1; // -1 signifie qu'aucun élément n'est sélectionné initialement

function updateItems() {
	menuItems.forEach(function(spr:FunkinSprite) {
		if (spr.ID == curSelected) {
			spr.animation.play('hover');

			if (lastSelected != curSelected || lastSelected == -1) {
				lastSelected = curSelected;

				var photoPath:String = Paths.image("menus/freeplay/" + optionShit[curSelected]); 
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
	selSmth = true;
	confirm.play();
	switchState();
}

function switchState() {
	var daChoice:String = optionShit[curSelected];
	var selectedDifficulty:String = difficultyOptions[curDifficulty];

	PlayState.loadSong(optionShit[curSelected], selectedDifficulty);
	FlxG.switchState(new PlayState());
}

function changeSelection(change:Int = 0, force:Bool = false) {
	if (change == 0 && !force)
		return;

	FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);
	curSelected += change;
	if (curSelected >= optionShit.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = optionShit.length - 1;
}

function changeDifficulty(change:Int) {
	FlxG.sound.play(Paths.sound('menu/scroll'));
	curDifficulty += change;

	if (curDifficulty < 0)
		curDifficulty = difficultyOptions.length - 1;
	if (curDifficulty >= difficultyOptions.length)
		curDifficulty = 0;

	// Update the difficulty text when changing
	difficultyText.text = "Difficulty: " + difficultyOptions[curDifficulty].toUpperCase();

	// Center the difficulty text between arrows
	difficultyText.x = 650;

	// Add a visual pulse effect when changing difficulty
	FlxTween.tween(difficultyText.scale, {x: 1.1, y: 1.1}, 0.1, {
		ease: FlxEase.quadOut,
		onComplete: function(twn:FlxTween) {
			FlxTween.tween(difficultyText.scale, {x: 1, y: 1}, 0.1, {ease: FlxEase.quadIn});
		}
	});
}
