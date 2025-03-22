import funkin.backend.MusicBeatState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
var steps = 0;

function create(){


    logo = new FunkinSprite(150,100, Paths.image("menus/title/teamlogo"));
    XMLUtil.addAnimToSprite(logo, {
        name: "teamlogo",
        anim: "Intro",
        fps: 20,
        loop: false,
        animType: "loop" , //if you use "loop" then it automatically plays the last added animation
        x: 0, // offsetX
        y: 0, // offsetY
        indices: [],
        forced: false, // If everytime the animation plays, it should be forced to play
    });
    logo.playAnim("teamlogo", false);
    add(logo);
    logo.updateHitbox(); 
    logo.antialiasing = true;
    logo.scale.set(0.6, 0.6);

    FlxTransitionableState.skipNextTransIn = true;
    FlxTransitionableState.skipNextTransOut = true;

    new FlxTimer().start(3, function() {
        FlxTween.tween(logo, {alpha: 0}, 2, {onComplete:
            function(twn:FlxTween)
            {
                FlxG.switchState(new MainMenuState());
            }
        });
    });
  
}


function update(elapsed:Float) {
	if (controls.ACCEPT)
			FlxG.switchState(new MainMenuState());
}