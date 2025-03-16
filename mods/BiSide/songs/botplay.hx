import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextAlign;
import flixel.util.FlxColor;

var botplayTxts:Array<FlxText> = [];
static var curBotplay:Bool = false;
var letterTexts:Array<FlxText> = [];

curBotplay = false;

function postCreate() {
    // Create array for individual letters
    var letters = ['B', 'O', 'T', 'P', 'L', 'A', 'Y'];
    var letterSpacing = 25;
    var posX = 550;
    var posY = 80;
    
    for (i in 0...letters.length) {
        var letter = new FlxText(posX + (i * letterSpacing), posY, null, letters[i], 32);
        letter.setFormat(Paths.font("MPLUSRounded1c-Black.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        letter.borderSize = 1.25;
        letter.camera = camHUD;
        letter.visible = curBotplay;
        letterTexts.push(letter);
        add(letter);
    }
}

function updateLetterColors(elapsed:Float) {
    var colors = [
        FlxColor.fromRGB(255, 0, 255), // Purple
        FlxColor.fromRGB(0, 255, 255)  // Cyan
    ];
    
    var frequency = 5;
    var phase = botplaySine / 180 * Math.PI;
    
    var i = 0;
    for (letter in letterTexts) {
        var interpolation = (Math.sin(phase + (i * 0.5)) + 1) / 2;
        var color = FlxColor.interpolate(colors[0], colors[1], interpolation);
        letter.color = color;
        i++;
    }
}

var leAlpha:Float = 0;
public var botplaySine:Float = 0;

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.B) curBotplay = !curBotplay;
    
    // Update botplay status for all strumlines
    for (strumLine in strumLines) {
        if (!strumLine.opponentSide) {
            strumLine.cpu = curBotplay;
        }
    }
    
    // Update text visibility
    for (letter in letterTexts) {
        letter.visible = curBotplay;
    }
    
    if (curBotplay) {
        botplaySine += 180 * elapsed;
        leAlpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
        updateLetterColors(elapsed);
        
        // Update alpha for all letters
        for (letter in letterTexts) {
            letter.alpha = leAlpha;
        }
    }
}