function postUpdate(elapsed) {
	camFollow.setPosition(500, 805);
}

import openfl.display.BlendMode;

var adjustColorBF = new CustomShader('adjustColor');
var adjustColorDad = new CustomShader('adjustColor');

function create() {
	boyfriend.shader = adjustColorBF;
	dad.shader = adjustColorDad;

	adjustColorBF.brightness = -50;
	adjustColorBF.hue = 0;
	adjustColorBF.contrast = 10;
	adjustColorBF.saturation = -10;

	adjustColorDad.brightness = -30;
	adjustColorDad.hue = 0;
	adjustColorDad.contrast = 0;
	adjustColorDad.saturation = -30;

	chibiBidiovelray.blend = 0;
	trace(chibiBidiovelray.blend);
}
