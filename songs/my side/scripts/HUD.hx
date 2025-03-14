import flixel.math.FlxRect;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;

var leftHealth:FlxSprite;
var rightHealth:FlxSprite;
var __healthScale:Float = 0.65;
var comboText:FlxText;
var charhud:FlxSprite;
var customHealth:Float = 1.0; // Start with full health (1.0 = 100%)


// Adjust these values to fine-tune how much health changes
var HEALTH_GAIN_PER_HIT:Float = 0.01;   // Small increase when hitting a note
var HEALTH_LOSS_PER_MISS:Float = 0.05;  // More noticeable decrease when missing a note

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

    // Create the character sprite
    charhud = new FlxSprite(0, 0);
    CoolUtil.loadAnimatedGraphic(charhud, Paths.image("characters/bidi/bidibop"));
    // Add the animation with initial fps
    charhud.animation.addByPrefix('idle', 'bidibop', 24, true);
    charhud.animation.play('idle');
    // Adjust animation speed separately
    charhud.animation.curAnim.frameRate = 15;

    // Set position
    charhud.x = 40;
    charhud.y = 530;
    charhud.camera = camHUD;
    // Set scale
    charhud.scale.set(0.2, 0.2);
    charhud.updateHitbox();

    // Positionner la barre de vie à gauche
    leftHealth = new FlxSprite(285, -135, leftFillerPath);
    leftHealth.camera = camHUD;
    leftHealth.setGraphicSize(Std.int(leftHealth.width * __healthScale));
    leftHealth.updateHitbox();
    leftHealth.scale.set(0.58, 0.58);
    leftHealth.y = FlxG.height - leftHealth.height - 135;
    leftHealth.origin.x = 0; // Set origin to left side, so scaling happens from left to right

    rightHealth = new FlxSprite(leftHealth.x + leftHealth.width + 5, leftHealth.y, rightFillerPath);
    rightHealth.camera = camHUD;
    rightHealth.setGraphicSize(Std.int(rightHealth.width * __healthScale));
    rightHealth.updateHitbox();
    rightHealth.scale.set(0.58, 0.58);
    rightHealth.onDraw = function(spr:FlxSprite) {
        spr.setPosition(leftHealth.x, leftHealth.y);
        spr.draw();
    };

    comboText = new FlxText(90, 0, 0, "0", 32);
    comboText.setFormat(Paths.font("MPLUSRounded1c-Bold.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER);
    comboText.x = 96;
    comboText.y = 503;
    comboText.cameras = [camHUD];

    if (downscroll) {
        comboText.y = 492;
        leftHealth.y = FlxG.height - leftHealth.height - 78;
    }

    insert(members.indexOf(iconP1), ui);
    insert(members.indexOf(iconP1), charhud);
    insert(members.indexOf(iconP1), rightHealth);
    insert(members.indexOf(iconP1), leftHealth);
    insert(members.indexOf(iconP1), comboText);
}

// Increase health when player hits a note
function onPlayerHit() {
    customHealth += HEALTH_GAIN_PER_HIT;
    if (customHealth > 1.0) customHealth = 1.0; // Cap at 1.0
    
    // Update the health bar
    updateHealthBar();
}

// Decrease health when player misses a note
function onPlayerMiss() {
    customHealth -= HEALTH_LOSS_PER_MISS;
    if (customHealth < 0.0) customHealth = 0.0; // Don't let it go below 0
    
    // Update the health bar
    updateHealthBar();
}

// Also handle pressed misses
function noteMissPress(direction) {
    customHealth -= HEALTH_LOSS_PER_MISS;
    if (customHealth < 0.0) customHealth = 0.0;
    
    // Update the health bar
    updateHealthBar();
}

// Helper function to update the health bar
function updateHealthBar() {
    leftHealth.scale.x = 0.58 * customHealth;
}

// Basic update for combo text
function update(elapsed) {
    // Update combo text
    comboText.text = combo;
    
    // Adjust combo text position based on digits
    if (combo < 10) {
        comboText.x = 96;
    } else if (combo >= 10 && combo < 100) {
        comboText.x = 90;
    } else if (combo >= 100) {
        comboText.x = 86;
    }
}
