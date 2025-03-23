import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxTextBorderStyle;
import openfl.text.TextFormat;
import openfl.geom.Rectangle;
import funkin.options.OptionsMenu;
import funkin.options.keybinds.KeybindsOptions;

var itemArray:Array<{sprite:FunkinSprite, lerp:Float}> = [];
var camPause:FlxCamera;
var menuItems:Array<String> = ["Resume", "Restart", "Options", "Controls", "Exit"];
var curSelected:Int = 0;
var pauseMusic:FlxSound;
var wall:FlxSprite;
var render:FunkinSprite;
var canSelect:Bool = false;
public var shouldShowHUD = false;

var mouseTrackerX:Float = 0;
var mouseTrackerY:Float = 0;
var usingMouse:Bool = true;

function create() {
	// Configuration de l'état pause
	FlxG.state.persistentUpdate = false;
	FlxG.state.persistentDraw = true;
	FlxG.state.paused = true;

	// Initialisation de la caméra pause
	camPause = new FlxCamera();
	camPause.bgColor = 0x0000FFFF;
	FlxG.cameras.add(camPause, false);
	camPause.alpha = 1;
	camPause.zoom = 1;

	canSelect = true;

	blackBarThingie = new FlxSprite().makeSolid(FlxG.width + 500, 0, FlxColor.BLACK);
	blackBarThingie.setGraphicSize(Std.int(blackBarThingie.width + 400));
	blackBarThingie.scrollFactor.set(0, 0);
	blackBarThingie.screenCenter();
	blackBarThingie.alpha = 0.4;
	add(blackBarThingie);
	blackBarThingie.cameras = [camPause];

	menulogo = new FlxSprite(100, 180).loadGraphic(Paths.image('menus/PauseMenu/Menu'));
	add(menulogo);
	menulogo.scale.set(0.72, 0.72);
	menulogo.cameras = [camPause];

	pauselogo = new FlxSprite(80, 60).loadGraphic(Paths.image('menus/PauseMenu/Pause'));
	add(pauselogo);
	pauselogo.scale.set(0.72, 0.72);
	pauselogo.cameras = [camPause];

	render = new FlxSprite(-350, -420).loadGraphic(Paths.image('menus/PauseMenu/' + PlayState.instance.curSong));
	render.scale.set(0.4, 0.4);
	render.cameras = [camPause];
	add(render);

	// Ajout de la musique de pause
	pauseMusic = FlxG.sound.load(Paths.music("breakfast"), 0, true);
	pauseMusic.persist = false;
	pauseMusic.group = FlxG.sound.defaultMusicGroup;
	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	// Création des options du menu
	for (index in 0...menuItems.length) {
		var item:FunkinSprite = new FunkinSprite(0, 50);
		item.frames = Paths.getSparrowAtlas("menus/PauseMenu/menubuttons");
		item.animation.addByPrefix("idle", menuItems[index] + "UnSelected", 24, true);
		item.animation.addByPrefix("hover", menuItems[index] + "Selected", 24, true);
		item.playAnim("idle", true);
		item.ID = index;
		item.scale.set(1, 1);
		item.updateHitbox();
		item.x = 120;
		item.y = 250 + (50 * index);
		item.cameras = [camPause];
		add(item);

		itemArray.push({sprite: item, lerp: 0.2});
	}

	camPause.flash(FlxColor.WHITE, 0.2);
}

// Add this new function to handle returning from submenus
function onSubStateClose() {
	canSelect = true; // Re-enable selection when returning from submenu
}

function update(elapsed:Float) {
	if (pauseMusic.volume < 0.3) pauseMusic.volume += 0.02 * elapsed;

	if (!canSelect)
		return;

	// Keyboard controls
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
	else if (FlxG.keys.justPressed.ESCAPE) {
		FlxG.camera.setFilters([]);
		PlayState.instance.camHUD.setFilters([]);
		blackBarThingie.alpha = 0;
		close();
		pauseMusic.volume = 0;
	}

	for (i in 0...itemArray.length) {
		var item = itemArray[i].sprite;
		if (FlxG.mouse.overlaps(item) || curSelected == item.ID) {
			curSelected = item.ID;
			changeSelection(0);
			if ((FlxG.mouse.justPressed && usingMouse) || controls.ACCEPT) {
				selectItem(menuItems[curSelected]);
			}
			break;
		}
		else {
			item.animation.play("idle");
		}
	}

	if (FlxG.mouse.x != mouseTrackerX && FlxG.mouse.y != mouseTrackerY){
        usingMouse = true;
    }
}

function changeSelection(change:Int) {
	curSelected += change;

	if (curSelected < 0)
		curSelected = menuItems.length - 1;
	if (curSelected >= menuItems.length)
		curSelected = 0;

	for (i in 0...itemArray.length) {
		var item = itemArray[i].sprite;
		if (FlxG.mouse.overlaps(item) || curSelected == item.ID) {
			item.animation.play("hover");
		}
		else {
			item.animation.play("idle");
		}
	}
}

function selectItem(option:String) {
	FlxG.camera.setFilters([]);
	PlayState.instance.camHUD.setFilters([]);
	switch (option) {
		case "Resume":
			blackBarThingie.alpha = 0;
			close();
			pauseMusic.volume = 0;
		case "Restart":
			PlayState.instance.registerSmoothTransition();
			FlxG.resetState();
		case "Options":
			FlxG.switchState(new OptionsMenu());
		case "Controls":
			var keybindsSubState = new KeybindsOptions();
			keybindsSubState.closeCallback = onSubStateClose; // Set the callback
			openSubState(keybindsSubState);
			persistentDraw = false;
		case "Exit":
			FlxG.switchState(new MainMenuState());
	}
}
