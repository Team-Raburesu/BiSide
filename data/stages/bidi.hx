import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import funkin.backend.shaders.FunkinShader;

import openfl.display.BlendMode;

var adjustColorBG = new CustomShader('adjustColor');




function onCountdown(event) {
    // Augmenter la taille du compteur (Ready, Set, Go)
    var scaleFactor = 1.5; // Change cette valeur pour ajuster la taille
    event.scale = scaleFactor;
     defaultCamZoom = 0.8;
     camZooming = true;

    // Garder le texte par défaut (sans chemin personnalisé)
    event.spritePath = switch(event.swagCounter) {
        case 0: null; // Rien pour 0
        case 1: 'game/ready'; // Ready
        case 2: 'game/set';   // Set
        case 3: 'game/go';    // Go
    };
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1: defaultCamZoom = 0.8;
        case 256: bg.alpha = 0;
        boyfriend.alpha = 1;
        boyfriend.x = 900;
        boyfriend.y = -100;
        dad.x = -100;
        boyfriend.scale.set(0.65, 0.65);
        defaultCamZoom = 0.6;
        case 386:  

    bg2.shader = adjustColorBG;


    FlxTween.num(0, -73, 4, {ease: FlxEase.Linear}, function(asf) adjustColorBG.brightness = asf);
    
    blackBarThingie = new FlxSprite().makeSolid(FlxG.width, FlxG.height,  0xFF873e23);
    blackBarThingie.setGraphicSize(Std.int(blackBarThingie.width + 900));
    blackBarThingie.scrollFactor.set(0, 0);
    blackBarThingie.screenCenter();
    insert(members.indexOf(boyfriend) + 1, blackBarThingie);
    blackBarThingie.blend  = 9;
    blackBarThingie.alpha = 0;
    FlxTween.tween(blackBarThingie, { alpha: 0.4 }, 4, { ease: FlxEase.quadInOut, type: FlxTween.BACKINOUT });



            
    }
}

