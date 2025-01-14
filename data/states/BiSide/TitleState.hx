import funkin.backend.MusicBeatState;

var steps = 0;

function create(){

    logo = new FlxSprite(0, 20);
    CoolUtil.loadAnimatedGraphic(logo, Paths.image("menus/titlescreen/logo"));
    logo.antialiasing = true;
    add(logo);
    logo.alpha = 0;
    logo.scale.set(0.7, 0.7);
    logo.screenCenter(FlxAxes.X);

    new FlxTimer().start(0.1, function() {
			FlxTween.tween(logo, {alpha: 1}, 2);
            FlxTween.tween(logo, {y: 0}, 2, {ease: FlxEase.backInOut});
            FlxTween.tween(logo.scale, {x: 0.8 ,y:0.8}, 2, {ease: FlxEase.backInOut});
            
            new FlxTimer().start(3, function() {
                 FlxG.switchState(new MainMenuState());
            });
    });
}
