import flixel.addons.display.FlxBackdrop;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.text.FlxTextBorderStyle;
import funkin.options.OptionsMenu;
import openfl.ui.Mouse;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import hxvlc.flixel.FlxVideoSprite;
import Sys;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;
import funkin.backend.utils.DiscordUtil;

var codenameVersion = Application.current.meta.get('version');
var snow = new FlxVideoSprite(-100);
var optionShit:Array<String> = ["StoryMode", "Freeplay", "Credits", "Options", "Bug_reports", "Exit"];
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var menuItemsHitboxes:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var menuItem:FunkinSprite;
var camZoom:FlxTween;
var usingMouse:Bool = true;
var confirm:FlxSound;
var locked:FlxSound;
var cancel:FlxSound;
var hover:FlxSound;
var curSelected:Int = 0;
var difficultyOptions:Array<String> = ["Easy", "Normal", "Hard"];
var difficultyText:Array<FlxText> = [];
var diffIMGS:Array<FlxSprite> = [];
var curDifficulty:Int = 1; // "Normal" par défaut
var selectingDifficulty:Bool = false;
var codeInput:String = "";
var codeTimeout:FlxTimer = null;

function create() {
	CoolUtil.playMenuSong();
	FlxG.mouse.visible = true;

	confirm = FlxG.sound.load(Paths.sound('menu/confirm'));
	cancel = FlxG.sound.load(Paths.sound('menu/cancel'));
	hover = FlxG.sound.load(Paths.sound('menu/scroll'));

	DiscordUtil.changePresenceSince("Main Menu", null);

	bg = new FlxSprite(-80).loadGraphic(Paths.image('menus/mainmenu/bg'));
	add(bg);
	bg.screenCenter();
	bg.scale.set(0.72, 0.72);
	bg.scrollFactor.set(0, 0);

	menulogo = new FlxSprite(100, 60).loadGraphic(Paths.image('menus/mainmenu/MainMenuLogo'));
	add(menulogo);
	menulogo.alpha = 0;
	FlxTween.tween(menulogo, {alpha: 1}, 1, {ease: FlxEase.expoIn});

	menutext = new FlxSprite(-500, 200).loadGraphic(Paths.image('menus/mainmenu/MainMenutext'));
	add(menutext);
	menutext.scale.set(0.5, 0.5);
	FlxTween.tween(menutext, {x: 0}, 1, {ease: FlxEase.expoOut});

	bidyBody = new FlxSprite(500, 320).loadGraphic(Paths.image('menus/mainmenu/bidi/body'));
	add(bidyBody);
	bidyBody.scale.set(0.6, 0.6);
	bidyBody.antialiasing = true;

	bidyhead = new FlxSprite(180, -540).loadGraphic(Paths.image('menus/mainmenu/bidi/head'));
	add(bidyhead);
	bidyhead.scale.set(0.6, 0.6);
	bidyhead.antialiasing = true;

	bidyEyes = new FlxSprite(740, 160).loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes'));
	add(bidyEyes);
	bidyEyes.scale.set(0.6, 0.6);
	bidyEyes.antialiasing = true;

	for (i in 0...optionShit.length) {
		menuItem = new FunkinSprite(0, 220);
		menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menubuttons');
		menuItem.animation.addByPrefix('idle', optionShit[i] + 'UnSelected', 8, true);
		menuItem.animation.addByPrefix('hover', optionShit[i] + 'Selected', 8, true);
		menuItem.ID = i;
		menuItems.add(menuItem);
		menuItem.scale.set(1, 1);
		menuItem.antialiasing = true;
		
		menuItem.x = -500;
		menuItem.y += menuItem.height + 45 * i;
		if(i == 5) menuItem.y += 15;

		var delay:Float = i * 0.05;
		FlxTween.tween(menuItem, {x: 100}, 1, {
			startDelay: delay,
			ease: FlxEase.expoOut
		});
	}
	moveCamera();
	for (i in 0...difficultyOptions.length) {
		var lol = new FlxSprite(0, 100).loadGraphic(Paths.image('menus/' + difficultyOptions[i].toLowerCase()));
		lol.scale.set(0.5, 0.5);
		lol.updateHitbox();
		lol.antialiasing = false;
		lol.x += ((lol.width + 50) * i) + 120;
		lol.alpha = 0;
		add(lol);
		diffIMGS.push(lol);

		var text = new FlxText(120 + (i * 400), 470, 0, difficultyOptions[i], 32);
		text.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 90, FlxColor.WHITE, FlxTextAlign.CENTER);
		text.alpha = 0; // Invisible tant que le menu de difficulté n'est pas affiché
		text.antialiasing = true;
		add(text);
		switch(i)
		{
			case 0:
				text.x += 40;
			case 1:
				text.x -= 30;
		}
		difficultyText.push(text);
	}
	add(menuItems);
	updateItems();
}

var selectedSomethin:Bool = false;
var exitHoverCount:Int = 0;
var isHoveringExit:Bool = false;
var wigglingExit:Bool = false;

var openedCredit:Bool = false;
var credit:FlxSprite;

function openDaCredits() {
	credit = new FlxSprite(600, 60).loadGraphic(Paths.image('menus/credits'));
	add(credit);
	credit.scale.set(0.2, 0.2);

	FlxTween.tween(credit, {x: FlxG.width / 2 - credit.width / 2, y: FlxG.height / 2 - credit.height / 2}, 1.4, {ease: FlxEase.expoOut});
	FlxTween.tween(credit.scale, {x: 1, y: 1}, 1.4, {ease: FlxEase.expoOut,
		onComplete: function(twn:FlxTween)
		{
			openedCredit = true;
		},
		onUpdate: function(twn:FlxTween)
		{
			credit.updateHitbox();
		}
	});
}

function closeDaCredit() {
	openedCredit = false;
	FlxTween.tween(credit.scale, {x: 0.01, y: 0.01}, 0.5, {ease: FlxEase.expoOut,
		onUpdate: function(twn:FlxTween)
		{
			credit.screenCenter();
		},
		onComplete: function(twn:FlxTween)
		{
			credit.destroy();
			selectedSomethin = false;
		}
	});

	revertMenu();
}

function update(elapsed) {
	// Check for secret code input
	if (!selectedSomethin && !selectingDifficulty && !openedCredit) {
		// Check each key press
		if (FlxG.keys.justPressed.ANY) {
			var keyString = "";

			// Convert key press to character
			if (FlxG.keys.justPressed.S)
				keyString = "s";
			else if (FlxG.keys.justPressed.K)
				keyString = "k";
			else if (FlxG.keys.justPressed.I)
				keyString = "i";
			else if (FlxG.keys.justPressed.B)
				keyString = "b";
			else if (FlxG.keys.justPressed.D)
				keyString = "d";

			// If it's a relevant key, add to input
			if (keyString != "") {
				codeInput += keyString;

				// Reset timeout timer
				if (codeTimeout != null) {
					codeTimeout.cancel();
				}

				// Create new timeout
				codeTimeout = new FlxTimer().start(2, function(timer) {
					codeInput = ""; // Reset code input after timeout
				});

				// Check if the code matches
				if (codeInput == "skibidi") {
					confirm.play();
					startSecretSong();
					codeInput = ""; // Reset code
				}
			}
		}
	}

	// ...existing update code continues below...
	if (selectingDifficulty) {
		if (FlxG.keys.justPressed.LEFT)
			changeDifficulty(-1);
		else if (FlxG.keys.justPressed.RIGHT)
			changeDifficulty(1);
		else if (FlxG.keys.justPressed.ENTER)
			startStoryMode();
		else if (controls.BACK) {
			closeDifficultyMenu();
			selectedSomethin = false;
		}
	}

	if (openedCredit && controls.BACK) {
		closeDaCredit();
	}

	if (FlxG.keys.justPressed.ENTER && !openedCredit) {
		usingMouse = false;
		var selectedItem = menuItems.members[curSelected];
		if (selectedItem != null) {
			if (optionShit[curSelected] == "StoryMode") {
				openDifficultyMenu();
				selectItem();
			} else
				selectItem();
		}
	}

	FlxG.sound.music.volume = 0.5;

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = !(persistentDraw = true);
		openSubState(new EditorPicker());
	}

	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = !(persistentDraw = true);
	}

	if (FlxG.mouse.justMoved) {
		usingMouse = true;
	} else {
		usingMouse = false;
	}

	if (!selectedSomethin) {
		updateHead();
		updateEyes();
		if (usingMouse) {
			for (i in menuItems.members) {
				if (FlxG.mouse.overlaps(i)) {
					curSelected = menuItems.members.indexOf(i);
					updateItems();
					if (FlxG.mouse.justPressed){selectItem();}
				}
			}
		}
		changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
	}

	FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, camTargetX, 0.02);
	FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, camTargetY, 0.02);

	var exitButton = menuItems.members[5];
	if (FlxG.mouse.overlaps(exitButton)) {
		if (!isHoveringExit) {
			isHoveringExit = true;
			exitHoverCount++;
			if (exitHoverCount >= 6 && !wigglingExit)
				wiggleExitButton(exitButton);
		}
	} else
		isHoveringExit = false;

	if (!FlxG.mouse.overlaps(exitButton)) {
		bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes'));
		bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head'));
	}
}

function wiggleExitButton(button:FlxSprite) {
	wigglingExit = true;

	var originalX = button.x;
	var originalY = button.y;

	var maxRadius:Float = 50;

	function calculateNewPosition():Dynamic {
		var mouseX = FlxG.mouse.screenX;
		var mouseY = FlxG.mouse.screenY;

		var angle:Float = FlxG.random.float(0, Math.PI * 2);
		var offsetRadius:Float = FlxG.random.float(30, maxRadius);

		var newX:Float = originalX + Math.cos(angle) * offsetRadius;
		var newY:Float = originalY + Math.sin(angle) * offsetRadius;

		var dx = mouseX - newX;
		var dy = mouseY - newY;
		var distanceToMouse:Float = Math.sqrt(dx * dx + dy * dy);

		if (distanceToMouse < 30) {
			return calculateNewPosition();
		}

		return {x: newX, y: newY};
	}

	var newPosition = calculateNewPosition();

	FlxTween.tween(button, {
		x: newPosition.x,
		y: newPosition.y
	}, 0.2, {
		ease: FlxEase.expoInOut,
		onComplete: function(tween:FlxTween) {
			if (FlxG.mouse.overlaps(button)) {
				wiggleExitButton(button);
			} else {
				wigglingExit = false;
				FlxTween.tween(button, {x: originalX, y: originalY}, 0.5, {ease: FlxEase.expoOut});
			}
		}
	});
}

function updateItems() {
	menuItems.forEach(function(spr:FunkinSprite) {
		if (spr.ID == curSelected) {
			spr.animation.play('hover');
		} else {
			spr.animation.play('idle');
		}

		if (curSelected == 5) {
			bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes_frowning'));
			bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head_frowning'));
		} else {
			bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes'));
			bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head'));
		}

		var exitButton = menuItems.members[5];
		if (!FlxG.mouse.overlaps(exitButton)) {
			bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes'));
			bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head'));
		}
	});
}

var bugReportUrlOpened:Bool = false;

function selectItem() {
	selectedSomethin = true;
	confirm.play();
	FlxTween.cancelTweensOf(menuItem);

	switch (optionShit[curSelected])
	{
		case 'Bug_reports':
			if (!bugReportUrlOpened) {
				bugReportUrlOpened = true;
				CoolUtil.openURL("https://discord.gg/G5dYK59cHv");
		
				// Set a small timer to reset the UI state
				new FlxTimer().start(0.3, function(tmr:FlxTimer) {
					selectedSomethin = false;
					bugReportUrlOpened = false; // Reset the flag after a delay
		
					// No need to restore UI elements since we didn't animate them away
					updateItems();
				}, 1);
			}
			return;
		default:
			// changed the x property of the tweens so it would be much easier to deal with the transitions
			FlxTween.tween(menulogo, {y: -260, alpha: 0}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(menutext, {x: 1000, alpha: 0}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(bidyhead, {x: 1080, alpha: 0}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(bidyEyes, {x: 1640, alpha: 0}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(bidyBody, {x: 1400, alpha: 0}, 0.5, {ease: FlxEase.expoOut});

			for (item in menuItems.members) {
				var delay:Float = item.ID * 0.05;
		
				FlxTween.tween(item, {x: 1000, alpha: 0}, 1, {
					startDelay: delay,
					ease: FlxEase.expoOut,
				});
			}
	}
	switchState(optionShit[curSelected]);
}

function switchState(daChoice:String) {
	switch (daChoice) {
		case 'StoryMode':
			openDifficultyMenu();
		case 'Freeplay':
			openSubState(new ModSubState("BiSide/FreeplayScreen"));
			persistentUpdate = false;
			persistentDraw = true;
		case 'Options':
			FlxG.switchState(new OptionsMenu());
		case 'Credits':
			openDaCredits();
		case "Bug_reports":
			
		case "Exit":
			Sys.exit();
	}
}

function changeSelection(change:Int = 0, force:Bool = false) {
	if (change == 0 && !force)
		return;

	FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);

	usingMouse = false;

	curSelected += change;

	if (curSelected >= menuItems.length)
		curSelected = 0; // Loop back to first
	if (curSelected < 0)
		curSelected = menuItems.length - 1; // Loop to last

	for (item in menuItems.members) {
		if (item.ID == curSelected) {
			item.animation.play("hover", true);
		} else {
			item.animation.play("idle", true);
		}
	}
}

function updateEyes() {
	var eyeInitialX = 720;
	var eyeInitialY = 170;

	var mouseX = FlxG.mouse.screenX;
	var mouseY = FlxG.mouse.screenY;

	var dx = mouseX - (eyeInitialX + bidyEyes.width / 2);
	var dy = mouseY - (eyeInitialY + bidyEyes.height / 2);

	var divisor = 20;
	var offsetX = dx / divisor;
	var offsetY = dy / divisor;

	bidyEyes.x = FlxMath.lerp(bidyEyes.x, eyeInitialX + offsetX, 0.2);
	bidyEyes.y = FlxMath.lerp(bidyEyes.y, eyeInitialY + offsetY, 0.2);
}

var previousAngle:Float = 0;

function updateHead() {
	function sign(value:Float):Int {
		return (value > 0) ? 1 : (value < 0) ? -1 : 0;
	}

	var headCenterX = bidyhead.x;
	var headCenterY = bidyhead.y;

	var mouseX = FlxG.mouse.screenX;
	var mouseY = FlxG.mouse.screenY;

	var dx = mouseX - headCenterX;
	var dy = mouseY - headCenterY;

	var angleRad = Math.atan2(dy, dx);
	var angleDeg = angleRad * (20 / Math.PI);

	var maxRotation = 105;
	angleDeg = Math.max(-maxRotation, Math.min(maxRotation, angleDeg));

	var maxDelta = 100;
	if (Math.abs(angleDeg - previousAngle) > maxDelta) {
		angleDeg = previousAngle + sign(angleDeg - previousAngle) * maxDelta;
	}

	bidyhead.angle = FlxMath.lerp(bidyhead.angle, angleDeg * -0.5, 0.1);
	previousAngle = angleDeg;
}

function clamp(value:Float, min:Float, max:Float):Float {
	return Math.max(min, Math.min(max, value));
}

function sign(value:Float):Int {
	return (value > 0) ? 1 : (value < 0) ? -1 : 0;
}

// Ouvrir le menu de sélection de difficulté
function openDifficultyMenu() {
	selectingDifficulty = true;

	// Masquer les éléments du menu principal
	menuItems.visible = false;
	menutext.visible = false;

	// Afficher les options de difficulté avec un effet de fondu
	for (text in difficultyText) {
		FlxTween.tween(text, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
	}

	for (lol in diffIMGS) {
		FlxTween.tween(lol, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});		
	}

	updateDifficultySelection();
}

function revertMenu() {
	FlxTween.tween(menulogo, {y: 60, alpha: 1}, 0.5, {ease: FlxEase.expoOut});
	FlxTween.tween(menutext, {x: 0, alpha: 1}, 0.5, {ease: FlxEase.expoOut});
	FlxTween.tween(bidyhead, {x: 180, alpha: 1}, 0.5, {ease: FlxEase.expoOut});
	FlxTween.tween(bidyEyes, {x: 740, alpha: 1}, 0.5, {ease: FlxEase.expoOut});
	FlxTween.tween(bidyBody, {x: 500, alpha: 1}, 0.5, {ease: FlxEase.expoOut});

	for (item in menuItems.members) {
		item.x = -500;

		var delay:Float = item.ID * 0.05;
		FlxTween.tween(item, {x: 100, alpha: 1}, 0.5, {
			startDelay: delay,
			ease: FlxEase.expoOut,
		});
	}
}

// Fermer le menu de sélection de difficulté
function closeDifficultyMenu() {
	selectingDifficulty = false;
	cancel.play();

	menuItems.visible = true;
	menutext.visible = true;

	revertMenu();
	for (i in 0...menuItems.length) {
		var menuItem = menuItems.members[i];
		FlxTween.cancelTweensOf(menuItem);

		var delay:Float = i * 0.05;
		FlxTween.tween(menuItem, {x: 100, alpha: 1}, 0.6, {
			startDelay: delay,
			ease: FlxEase.quartOut
		});
	}

	// Cacher les options de difficulté
	for (text in difficultyText) {
		FlxTween.tween(text, {alpha: 0}, 0.3, {ease: FlxEase.quartOut});
	}

	for (lol in diffIMGS) {
		FlxTween.tween(lol, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});		
	}

	// Restaurer l'état des animations des boutons
	updateItems();
}

// Mettre à jour la sélection de la difficulté
function changeDifficulty(change:Int) {
	curDifficulty += change;

	if (curDifficulty < 0)
		curDifficulty = difficultyOptions.length - 1;
	if (curDifficulty >= difficultyOptions.length)
		curDifficulty = 0;

	updateDifficultySelection();
}

// Mettre en surbrillance l'option sélectionnée
function updateDifficultySelection() {
	for (i in 0...difficultyText.length) {
		if (i == curDifficulty) {
			// Met uniquement l'option sélectionnée en jaune et plus grande
			difficultyText[i].color = FlxColor.YELLOW;
			difficultyText[i].scale.set(1.2, 1.2);
		} else {
			// Réinitialise les autres options en blanc et taille normale
			difficultyText[i].color = FlxColor.WHITE;
			difficultyText[i].scale.set(1, 1);
		}
	}
}

// Lancer Story Mode avec la difficulté choisie
function startStoryMode() {
	var selectedDifficulty = difficultyOptions[curDifficulty].toLowerCase();

	PlayState.loadWeek({
		name: "storylmao",
		id: "storylmao",
		sprite: null,
		chars: [null, null, null],
		songs: [
			for (song in ["my-side", "looping-chorus", "no-friendship", "together-at-last"])
				{name: song, hide: false}
		],
		difficulties: ['hard']
	}, selectedDifficulty);

	FlxG.switchState(new PlayState());
}

var camTargetX:Float = 0;
var camTargetY:Float = 0;

function moveCamera() {
	// Generate random offsets
	var randomX = FlxG.random.float(-20, 20); // Small left/right movement
	var randomY = FlxG.random.float(-10, 10); // Small up/down movement
	var duration = FlxG.random.float(4, 6); // Random smooth duration

	var camTargetX = FlxG.camera.scroll.x + randomX; // Update the camera's target position
	var camTargetY = FlxG.camera.scroll.y + randomY;

	FlxTween.tween(FlxG.camera.scroll, {x: camTargetX, y: camTargetY}, duration, {
		ease: FlxEase.sineInOut,
		onComplete: function(_) {
			moveCamera(); // Loop the movement
		}
	});
}

// Add this new function to handle the secret song
function startSecretSong() {
	selectedSomethin = true;

	// Noir progressif
	var blackFade = new FlxSprite().makeGraphic(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
	blackFade.alpha = 0;
	blackFade.screenCenter();
	add(blackFade);

	// Slow down la musique + pitch drop
	FlxTween.tween(FlxG.sound.music, {pitch: 0.1, volume: 0}, 4, {ease: FlxEase.quadInOut});

	// Menu items tombent et tournent doucement
	for (i in 0...menuItems.length) {
		var item = menuItems.members[i];
		var delay = i * 0.1;
		FlxTween.tween(item, {
			y: item.y + 300,
			angle: FlxG.random.int(-15, 15),
			x: FlxG.random.int(-40, 50),
			alpha: 0
		}, 2, {startDelay: delay, ease: FlxEase.quartIn});
	}

	// Les éléments du perso tombent aussi
	FlxTween.tween(bidyBody, {y: bidyBody.y + 300, angle: 15, alpha: 0}, 2, {ease: FlxEase.quartIn});
	FlxTween.tween(bidyhead, {y: bidyhead.y + 300, angle: -15, alpha: 0}, 2, {ease: FlxEase.quartIn});
	FlxTween.tween(bidyEyes, {y: bidyEyes.y + 300, alpha: 0}, 2, {ease: FlxEase.quartIn});
	FlxTween.tween(menulogo, {y: menulogo.y + 300, alpha: 0}, 2, {ease: FlxEase.quartIn});
	FlxTween.tween(menutext, {y: menutext.y + 300, alpha: 0}, 2, {ease: FlxEase.quartIn});

	// Le fade noir arrive
	FlxTween.tween(blackFade, {alpha: 1}, 3.5, {
		ease: FlxEase.quadInOut,
		onComplete: function(_) {
			// Lancement du secret après tout
			PlayState.loadSong("secret", "hard");
			FlxG.switchState(new PlayState());
		}
	});
}
