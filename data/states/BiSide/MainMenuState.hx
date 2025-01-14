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

var codenameVersion = Application.current.meta.get('version');
var snow = new FlxVideoSprite(-100);

var optionShit:Array<String> = ["StoryMode", "Freeplay", "Credits", "Options", "Exit"];
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

function create() {
    CoolUtil.playMenuSong();
    FlxG.mouse.visible = true;

    confirm = FlxG.sound.load(Paths.sound('menu/confirm'));
    cancel = FlxG.sound.load(Paths.sound('menu/cancel'));
    hover = FlxG.sound.load(Paths.sound('menu/scroll'));

    bg = new FlxSprite(-80).loadGraphic(Paths.image('menus/mainmenu/bg'));
    add(bg);
    bg.screenCenter();
    bg.scale.set(0.72, 0.72);

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
        menuItem = new FunkinSprite(0, 0);
        menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menubuttons');
        menuItem.animation.addByPrefix('idle', optionShit[i] + 'UnSelected', 8, true);
        menuItem.animation.addByPrefix('hover', optionShit[i] + 'Selected', 8, true);
        menuItem.ID = i;
        menuItems.add(menuItem);
        menuItem.scale.set(1, 1);
        menuItem.antialiasing = true;

        var targetX:Int = 0;

        switch (optionShit[i]) {
            case "StoryMode":
                menuItem.setPosition(-500, 250);
                targetX = 100;
            case "Freeplay":
                menuItem.setPosition(-500, 295);
                targetX = 100;
            case "Credits":
                menuItem.setPosition(-500, 340);
                targetX = 100;
            case "Options":
                menuItem.setPosition(-500, 385);
                targetX = 100;
            case "Exit":
                menuItem.setPosition(-500, 450);
                targetX = 100;
        }

        var delay:Float = i * 0.05;
        FlxTween.tween(menuItem, {x: targetX}, 1, {
            startDelay: delay,
            ease: FlxEase.expoOut
        });
    }

    add(menuItems);
    updateItems();
}

var selectedSomethin:Bool = false;
var exitHoverCount:Int = 0;
var isHoveringExit:Bool = false;
var wigglingExit:Bool = false;

function update(elapsed) {
    FlxG.sound.music.volume = 0.5;

    if (FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = !(persistentDraw = true);
        openSubState(new EditorPicker());
    }

    if (controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = !(persistentDraw = true);
    }

    if (controls.BACK || FlxG.mouse.justPressedRight) {
        cancel.play();

        FlxTween.tween(FlxG.camera, {zoom: 1.2}, 2, {ease: FlxEase.expoOut});
        FlxG.camera.fade(FlxColor.BLACK, 0.5, false);

        new FlxTimer().start(.75, function(tmr:FlxTimer) {
            FlxG.switchState(new TitleState());
        });
    }

    if (FlxG.mouse.justMoved) {
        usingMouse = true;
    }

    if (!selectedSomethin) {
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
        changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
    }

    updateHead();
    updateEyes();

    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX - (FlxG.width / 2)) * 0, 1);
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY - (FlxG.height / 2)) * 0, 1);

    var exitButton = menuItems.members[4];
    if (FlxG.mouse.overlaps(exitButton)) {
        if (!isHoveringExit) {
            isHoveringExit = true;
            exitHoverCount++;

            if (exitHoverCount >= 6 && !wigglingExit) {
                wiggleExitButton(exitButton);
            }
        }
    } else {
        isHoveringExit = false;
    }
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
        }
        
        if (curSelected == 4) {
            bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes_frowning'));
            bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head_frowning'));
        } else {
            bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes'));
            bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head'));
        }

        var exitButton = menuItems.members[4];
        if (!FlxG.mouse.overlaps(exitButton)) {
            bidyEyes.loadGraphic(Paths.image('menus/mainmenu/bidi/Eyes'));
            bidyhead.loadGraphic(Paths.image('menus/mainmenu/bidi/Head'));
        }
    });
}

function switchState() {
    var daChoice:String = optionShit[curSelected];

    switch (daChoice) {
        case 'StoryMode':
            FlxG.switchState(new StoryMenuState());
        case 'Freeplay':
            openSubState(new ModSubState("BiSide/FreeplayScreen"));
            persistentUpdate = !(persistentDraw = true);
        case 'Option':
            FlxG.switchState(new OptionsMenu());
        case 'Credits':
            FlxG.switchState(new ModState("FD/CreditsScreen"));
        case "Discord":
            CoolUtil.openURL("https://discord.gg/Zc3QXmru6a");
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

function selectItem() {
    selectedSomethin = true;
    confirm.play();
    FlxTween.cancelTweensOf(menuItem);

    FlxTween.tween(menulogo, {alpha: 0, y:-100}, 1, {ease: FlxEase.expoOut});
    FlxTween.tween(menutext, {x: 200, alpha: 0}, 1, {ease: FlxEase.expoOut});
    FlxTween.tween(bidyhead, {x: 900 + bidyhead.x}, 1, {ease: FlxEase.expoOut});
    FlxTween.tween(bidyEyes, {x: 1400 + bidyEyes.x, alpha:0}, 1, {ease: FlxEase.expoOut});
    FlxTween.tween(bidyBody, {x: 900 + bidyBody.x}, 1, {ease: FlxEase.expoOut});

    for (i in 0...menuItems.length) {
        var menuItem = menuItems.members[i];
        var delay:Float = i * 0.05;

        var targetX = FlxG.width -700;

        FlxTween.tween(menuItem, {x: targetX, alpha: 0}, 1, {
            startDelay: delay,
            ease: FlxEase.expoOut,
        });
        switchState();
    }
}