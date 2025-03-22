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
var leftArrow:FlxText;
var rightArrow:FlxText;

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

	trace(optionShit);

	curSelected = 0; 
	lastSelected = -1;

	add(menuItems);

	difficultyText.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	difficultyText.x = 650; // Center the text
	difficultyText.y = 630;
	add(difficultyText);
	difficultyText.alpha = 0;

	// Add arrow text indicators properly positioned
	leftArrow = new FlxText(0, 630, 0, "<-", 48);
	leftArrow.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	leftArrow.x = 580; // Position to the left of the text
	add(leftArrow);
	leftArrow.alpha = 0;

	rightArrow = new FlxText(0, 630, 0, "->", 48);
	rightArrow.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER);
	rightArrow.x = 1120; // Position to the right of the text
	add(rightArrow);
	rightArrow.alpha = 0;

	FlxTween.tween(difficultyText, {alpha: 1}, 1, {ease: FlxEase.expoOut});
	FlxTween.tween(leftArrow, {alpha: 1}, 1, {ease: FlxEase.expoOut});
	FlxTween.tween(rightArrow, {alpha: 1}, 1, {ease: FlxEase.expoOut});
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

    // Improve click detection for difficulty arrows
    if (FlxG.mouse.justPressed) {
        // Get mouse position
        var mouseX = FlxG.mouse.x;
        var mouseY = FlxG.mouse.y;
        
        // Check if mouse is over left arrow
        if (mouseX >= leftArrow.x && mouseX <= leftArrow.x + leftArrow.width &&
            mouseY >= leftArrow.y && mouseY <= leftArrow.y + leftArrow.height) {
            changeDifficulty(-1);
            FlxG.sound.play(Paths.sound('menu/scroll'));
            
            // Visual feedback with safe tweening
            FlxTween.cancelTweensOf(leftArrow, ["color"]);
            leftArrow.color = FlxColor.WHITE;
            FlxTween.color(leftArrow, 0.1, FlxColor.WHITE, FlxColor.YELLOW, {ease: FlxEase.circOut});
            FlxTween.color(leftArrow, 0.1, FlxColor.YELLOW, FlxColor.WHITE, {ease: FlxEase.circIn, startDelay: 0.1});
        } 
        // Check if mouse is over right arrow
        else if (mouseX >= rightArrow.x && mouseX <= rightArrow.x + rightArrow.width &&
                 mouseY >= rightArrow.y && mouseY <= rightArrow.y + rightArrow.height) {
            changeDifficulty(1);
            FlxG.sound.play(Paths.sound('menu/scroll'));
            
            // Visual feedback with safe tweening
            FlxTween.cancelTweensOf(rightArrow, ["color"]);
            rightArrow.color = FlxColor.WHITE;
            FlxTween.color(rightArrow, 0.1, FlxColor.WHITE, FlxColor.YELLOW, {ease: FlxEase.circOut});
            FlxTween.color(rightArrow, 0.1, FlxColor.YELLOW, FlxColor.WHITE, {ease: FlxEase.circIn, startDelay: 0.1});
        }
    }

	updateItems();
    if (usingMouse) {
        for (i in menuItems.members) {
            if (FlxG.mouse.overlaps(i)) {
                curSelected = menuItems.members.indexOf(i);
                if (FlxG.mouse.justPressed) {
                    selectItem();
                }
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
	selectedSomethin = true;
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

	usingMouse = false;
	FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);
	curSelected += change;
	if (curSelected >= optionShit.length)
		curSelected = 0;
	if (curSelected < 0)
		curSelected = optionShit.length - 1;
}

function changeDifficulty(change:Int) {
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
