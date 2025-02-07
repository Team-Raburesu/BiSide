import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

var optionShit:Array<String> = ["MySide", "LoopingChorus", "NoFriendship", "TogetherAtLast"];
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var confirm:FlxSound;
var usingMouse:Bool = true;
var photoDisplay:FlxSprite; // Sprite pour afficher l'image sélectionnée


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
    photoDisplay = new FlxSprite(FlxG.width - 650, 100);
    photoDisplay.scale.set(1, 1);
    photoDisplay.antialiasing = true;
    add(photoDisplay);

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
    if (controls.BACK)
			 FlxG.resetState();
}

var lastSelected:Int = -1; // -1 signifie qu'aucun élément n'est sélectionné initialement


function updateItems() {
    menuItems.forEach(function(spr:FunkinSprite) {
        if (spr.ID == curSelected) {
            spr.animation.play('hover');

            // Vérifie si la sélection a changé
            if (lastSelected != curSelected) {
                lastSelected = curSelected; // Met à jour la sélection actuelle

                // Annule les tweens existants pour éviter les conflits
                FlxTween.cancelTweensOf(photoDisplay);

                // Mise à jour de l'image affichée
                var photoPath:String = switch (optionShit[curSelected]) {
                    case "MySide": Paths.image("menus/freeplay/MySidePhotograph");
                    case "LoopingChorus": Paths.image("menus/freeplay/LoopingChorusPhotograph");
                    case "NoFriendship": Paths.image("menus/freeplay/NoFriendshipPhotograph");
                    case "TogetherAtLast": Paths.image("menus/freeplay/TogetherAtLastPhoto");
                    default: null; // Par défaut, aucune image
                };

                if (photoPath != null) {
                    // Charger l'image correspondante
                    photoDisplay.loadGraphic(photoPath);
                    photoDisplay.visible = true; // Rendre visible
                    photoDisplay.updateHitbox();

                    // Appliquer une rotation et un "bop" d'échelle
                    var randomRotation:Float = FlxG.random.float(5, -5); // Rotation entre -15° et 15°
                    photoDisplay.angle = randomRotation;

                    // Animation d'échelle
                     
                    photoDisplay.scale.set(1.1, 1.1); // Réinitialiser l'échelle avant le tween
                    FlxTween.cancelTweensOf(photoDisplay);
                    FlxTween.tween(photoDisplay.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.elasticOut});
                    
                } else {
                    // Cacher le sprite si aucune image n'est sélectionnée
                    photoDisplay.visible = false;
                }
            }
        } else {
            spr.animation.play("idle", true);
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
            PlayState.loadSong("togetheratlastfr", "hard");
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
