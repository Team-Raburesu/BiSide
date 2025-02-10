import funkin.backend.MusicBeatState;

var steps = 0;

function create(){


    logo = new FunkinSprite(150,100, Paths.image("menus/title/teamlogo"));
    XMLUtil.addAnimToSprite(logo, {
        name: "teamlogo",
        anim: "Intro",
        fps: 24,
        loop: true,
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


            
    new FlxTimer().start(2, function() {
        FlxG.switchState(new MainMenuState());
    });
  
}


function update(elapsed:Float) {
	if (controls.ACCEPT)
			FlxG.switchState(new MainMenuState());



}