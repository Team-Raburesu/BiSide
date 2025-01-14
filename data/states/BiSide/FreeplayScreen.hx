import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

var optionShit:Array<String> = ["MySide", "LoopingChorus", "NoFriendship", "TogetherAtLast"];
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var confirm:FlxSound;
var usingMouse:Bool = true;

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
    trace(optionShit);
    add(menuItems);
    updateItems();
}

function update(elapsed) {
    if (FlxG.mouse.justMoved) {
        usingMouse = true;
    }

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

        changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
    }
}

function updateItems() {
    menuItems.forEach(function(spr:FunkinSprite) {
        if (spr.ID == curSelected) {
            spr.animation.play('hover');
        }
    });
}

function selectItem() {
    selectedSomethin = true;
    confirm.play();
    switchState();
}

function switchState() {
    var daChoice:String = optionShit[curSelected];

    switch (daChoice) {
        case 'MySide':
            PlayState.loadSong("MySide", "hard");
            FlxG.switchState(new PlayState());
        case 'LoopingChorus':
            PlayState.loadSong("LoopingChorus", "hard");
            FlxG.switchState(new PlayState());
        case 'NoFriendship':
            PlayState.loadSong("no friendship", "hard");
            FlxG.switchState(new PlayState());
        case 'TogetherAtLast':
            PlayState.loadSong("together at last", "hard");
            FlxG.switchState(new PlayState());
    }
}

function changeSelection(change:Int = 0, force:Bool = false) {
    if (change == 0 && !force) return;

    hover.play();

    usingMouse = false;

    curSelected += change;

    if (curSelected >= optionShit.length) {
        curSelected = 0;
    }
    if (curSelected < 0) {
        curSelected = optionShit.length - 1;
    }

    updateItems();
}
