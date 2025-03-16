import funkin.game.Stage;

var mouseSprite:FlxSprite;

function create() {
    FlxG.mouse.load(Paths.image('cursor'), 1);
    FlxG.mouse.useSystemCursor = false;
}

function update(elapsed:Float) {
    // Update the sprite position to follow the mouse
    mouseSprite.x = FlxG.mouse.x;
    mouseSprite.y = FlxG.mouse.y;
}

function destroy() {
    FlxG.mouse.visible = true;
    FlxG.mouse.useSystemCursor = true;
}