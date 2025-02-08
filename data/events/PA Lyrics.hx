import flixel.text.FlxTextBorderStyle;

var dalyricsa:FlxText;
var enableit:Bool;
var hideit:Bool;
public var coolassshader = new CustomShader("NewGlitch2");

function create() {
    for (event in events) {
        if (event.name == 'PA Lyrics') {
            dalyricsa = new FlxText(0, 165, 1200, "", 70);
            dalyricsa.setFormat(Paths.font("Digital Sans EF Medium.ttf"), 50, 0xFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            dalyricsa.scrollFactor.set();
            dalyricsa.borderColor = 0x00000000;
            dalyricsa.borderSize = 0;
            dalyricsa.screenCenter(FlxAxes.X);
            add(dalyricsa);
            dalyricsa.cameras = [camHUD];
            break;
        }
    }
}

function onEvent(e) {
    if (e.event.name != "PA Lyrics") return;
    
    var params = e.event.params;
    if (params[1] == '') {
        dalyricsa.text = '';
    } else {
        dalyricsa.text = params[1]; // Removed params[0] + ':' + '\n' +
    }
    
    dalyricsa.color = params[2];
    dalyricsa.borderColor = 0x00000000;
    
    enableit = params[3] == true;
    hideit = params[4] == true;
}

function stepHit(step:Int) {
    if (!enableit) return;
    coolassshader.binaryIntensity = FlxG.random.float(3, 6);
}

function postUpdate(elapsed) {
    dalyricsa.shader = enableit ? coolassshader : null;
}