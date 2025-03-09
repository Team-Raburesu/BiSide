

function postCreate() {
    benicutscene = new FunkinSprite(0,0, Paths.image("stages/beni/Benicutscene"));
    XMLUtil.addAnimToSprite(benicutscene, {
        name: "spritemap1",
        anim: "beni sequence",
        fps: 24,
        loop: true,
        animType: "loop" , //if you use "loop" then it automatically plays the last added animation
        x: 1940, // offsetX
        y: -750, // offsetY
        indices: [],
        forced: false, // If everytime the animation plays, it should be forced to play
    });
    benicutscene.playAnim("spritemap1", false);
    insert(2, benicutscene);
    benicutscene.scale.set(0.7, 0.7);
    dad.alpha = 0;

    	new FlxTimer().start(7, function(tmr:FlxTimer) {
			dad.alpha = 1;
            benicutscene.alpha = 0;
		});


}

