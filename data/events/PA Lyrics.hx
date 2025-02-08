import flixel.text.FlxTextBorderStyle;
var dalyricsa:FlxText;
var enableit:Bool;
var hideit:Bool;
public var coolassshader = new CustomShader("NewGlitch2");

function create() {
    for (event in events) {
        if (event.name == 'PA Lyrics') {
            dalyricsa = new FlxText(0, 165, 1200, "", 70);
            dalyricsa.setFormat(Paths.font("MPLUSRounded1c-Black.ttf"), 40, 0xFF5883B0, "center", FlxTextBorderStyle.OUTLINE_FAST, 0xFFFFFFFF);
            dalyricsa.scrollFactor.set(1500,200);
            dalyricsa.borderSize = 2.5;
            dalyricsa.borderQuality = 1;
            dalyricsa.screenCenter(FlxAxes.X);
            add(dalyricsa);
            dalyricsa.cameras = [camGame];
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
        dalyricsa.text = params[1];
    }
    
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