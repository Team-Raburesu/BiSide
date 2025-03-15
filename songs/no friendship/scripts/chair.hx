import flixel.FlxSprite;
import flixel.tweens.FlxTween;
var chair:FlxSprite;

function create() {
    chair = new FlxSprite().loadGraphic(Paths.image('chair'));
    chair.visible = false;
    chair.x = -400; 
    chair.y = 50;
    chair.alpha = 1;
    chair.scale.x = 1.35;
    chair.scale.y = 1.35;
}

function stepHit() {
    switch(curStep) {
        case 50: 
            chair.visible = true;
            insert(members.indexOf(dad), chair);
    }
}