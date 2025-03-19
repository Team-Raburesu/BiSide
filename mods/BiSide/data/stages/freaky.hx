import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import funkin.backend.shaders.FunkinShader;
import openfl.display.BlendMode;

var adjustColorBG = new CustomShader('adjustColor');
// Camera offset variables for boyfriend
var bfCamXOffset:Float = 0;
var bfCamYOffset:Float = 0;

function onCountdown(event) {
    // Augmenter la taille du compteur (Ready, Set, Go)
    var scaleFactor = 1.5; // Change cette valeur pour ajuster la taille
    event.scale = scaleFactor;
    defaultCamZoom = 0.6;
    camZooming = true;

    // Garder le texte par défaut (sans chemin personnalisé)
    event.spritePath = switch(event.swagCounter) {
        case 0: null; // Rien pour 0
        case 1: 'game/ready'; // Ready
        case 2: 'game/set';   // Set
        case 3: 'game/go';    // Go
    };
}

// Add this function to set boyfriend camera position
function setBfCamPosition(x:Float, y:Float) {
    bfCamXOffset = 100;
    bfCamYOffset = y;
    updateCameraPoints();
}

// Update camera focus points
function updateCameraPoints() {
    game.camFollow.boyfriendCamX = boyfriend.getMidpoint().x - 100 + bfCamXOffset;
    game.camFollow.boyfriendCamY = boyfriend.getMidpoint().y - 100 + bfCamYOffset;
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1:
            bg2.shader = adjustColorBG;
            FlxTween.num(0, -80, 0.5, {ease: FlxEase.Linear}, function(asf) adjustColorBG.brightness = asf);
            
            blackBarThingie = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF873e23);
            blackBarThingie.setGraphicSize(Std.int(blackBarThingie.width + 900));
            blackBarThingie.scrollFactor.set(0, 0);
            blackBarThingie.screenCenter();
            insert(members.indexOf(boyfriend) + 1, blackBarThingie);
            blackBarThingie.blend = 9;
            blackBarThingie.alpha = 0;
            FlxTween.tween(blackBarThingie, { alpha: 0.4 }, 4, { ease: FlxEase.quadInOut, type: FlxTween.BACKINOUT });
    }
}

// Add this function to make sure camera positions are updated when needed
function onUpdate(elapsed) {
    updateCameraPoints();
}
