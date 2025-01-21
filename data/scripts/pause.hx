import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

var menuOptions:Array<String> = ["Resume", "Restart", "Options", "Controls", "Exit"];
var menuItems:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var curSelected:Int = 0;
var inputBlocked:Bool = false;
var pauseCam:FlxCamera;
var confirmSound:FlxSound;
var scrollSound:FlxSound;
var cancelSound:FlxSound;

function create(event) {
    event.cancel();

    pauseCam = new FlxCamera();
    pauseCam.bgColor = 0xB0000000;
    pauseCam.alpha = 0;
    pauseCam.zoom = 1.25;
    FlxG.cameras.add(pauseCam, false);
    FlxTween.tween(pauseCam, {alpha: 1, zoom: 1}, 0.5, {ease: FlxEase.cubeOut});

    confirmSound = FlxG.sound.load(Paths.sound("menu/confirm"));
    scrollSound = FlxG.sound.load(Paths.sound("menu/scroll"));
    cancelSound = FlxG.sound.load(Paths.sound("menu/cancel"));

    for (i in 0...menuOptions.length) {
        var menuItem:FunkinSprite = new FunkinSprite(-500, 200 + (i * 45));
        menuItem.frames = Paths.getSparrowAtlas("menus/PauseMenu/menubuttons");
        menuItem.animation.addByPrefix("idle", menuOptions[i] + "UnSelected", 8, true);
        menuItem.animation.addByPrefix("hover", menuOptions[i] + "Selected", 8, true);
        menuItem.ID = i;
        menuItem.scale.set(1, 1);
        menuItem.antialiasing = true;

        FlxTween.tween(menuItem, {x: 100}, 1, {startDelay: i * 0.1, ease: FlxEase.expoOut});
        menuItems.add(menuItem);
    }

    add(menuItems);
    updateMenuItems();
    cameras = [pauseCam];
}

function destroy() FlxG.cameras.remove(pauseCam);

function update(elapsed:Float) {
    if (!inputBlocked) {
        if (FlxG.keys.justPressed.DOWN) {
            changeSelection(1);
        }
        if (FlxG.keys.justPressed.UP) {
            changeSelection(-1);
        }
        if (FlxG.keys.justPressed.ENTER) {
            inputBlocked = true;
            selectOption();
        }
        if (FlxG.keys.justPressed.ESCAPE) {
            cancelSound.play();
            closePauseMenu();
        }
    }

    updateMenuItems();
}

function changeSelection(change:Int) {
    if (menuOptions.length > 0) {
        curSelected += change;

        if (curSelected < 0) {
            curSelected = menuOptions.length - 1;
        } else if (curSelected >= menuOptions.length) {
            curSelected = 0;
        }

        updateMenuItems();
    }
}

function updateMenuItems() {
    for (item in menuItems.members) {
        if (item == null) continue;

        if (item.ID == curSelected) {
            item.animation.play("hover");
        } else {
            item.animation.play("idle");
        }
    }
}

function selectOption() {
    confirmSound.play();
    inputBlocked = true;

    switch (menuOptions[curSelected]) {
        case "Resume":
            closePauseMenu();
        case "Restart":
            FlxG.switchState(new MainMenuState());
             FlxG.switchState(new MainMenuState());
        case "Options":
            FlxG.switchState(new OptionsState());
        case "Controls":
            FlxG.switchState(new ControlsState());
        case "Exit":
            FlxG.switchState(new MainMenuState());
    }

    FlxTimer.delay(function() {
        inputBlocked = false;
    }, 0.5);
}

function closePauseMenu() {
    FlxTween.tween(pauseCam, {alpha: 0, zoom: 1.5}, 0.5, {
        ease: FlxEase.cubeOut,
        onComplete: function() FlxG.resetState()
    });
    inputBlocked = false;
}
