import hxvlc.flixel.FlxVideoSprite;

var cutscene = new FlxVideoSprite(0, 0);

function postCreate() {
    
    cutscene.bitmap.onFormatSetup.add(function() {
		cutscene.alpha = 1;
	});
	cutscene.load(Assets.getPath(Paths.video("MysideConceptWip")));
	add(cutscene);
	cutscene.play();
	cutscene.cameras = [camHUD];

}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 200: FlxTween.tween(cutscene, {alpha: 0}, 1); //change of when it finish
            
    }
}