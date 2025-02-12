import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.display.PNGEncoderOptions;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import funkin.backend.utils.NativeAPI;
import lime.graphics.Image;
import Sys;

static var SCREENSHOT_FOLDER = 'screenshots';
static var _region:Null<Rectangle>;
static var initialized:Bool = false;

static var redirectStates:Map<FlxState, String> = [
	TitleState => "BiSide/TitleState",
	MainMenuState => "BiSide/MainMenuState",
	StoryMenuState => "BiSide/MainMenuState",
	FreeplayState => "BiSide/MainMenuState",
];

function new() {
	if (FlxG.save.data.screenshotAmount == null)
		FlxG.save.data.screenshotAmount = 0;
	window.title = "BiSide";
}

function update() {
	if (FlxG.save.data.devMode) {
		if (FlxG.keys.justPressed.F5)
			FlxG.resetState();
		if (FlxG.keys.justPressed.F6)
			NativeAPI.allocConsole();
	}

	if (FlxG.keys.justPressed.F4)
		capture();
}

function preStateSwitch() {
	for (redirectState in redirectStates.keys())
		if (FlxG.game._requestedState is redirectState)
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
	window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconOG'))));
}

function capture() {
	var bitmap = new Bitmap(BitmapData.fromImage(FlxG.stage.window.readPixels()));
	saveScreenshot(bitmap);
	showCaptureFeedback();
	showFancyPreview(bitmap);
}

function showCaptureFeedback() {
	for (cam in FlxG.cameras.list) {
		cam.stopFX();
		cam.flash(FlxColor.WHITE, 0.35);
	}

	FlxG.sound.play(Paths.sound("screenshot"));
}

static var PREVIEW_INITIAL_DELAY = 0.25;
static var PREVIEW_FADE_IN_DURATION = 0.3;
static var PREVIEW_FADE_OUT_DELAY = 1.25;
static var PREVIEW_FADE_OUT_DURATION = 0.3;

function showFancyPreview(bitmap:Bitmap):Void {
	FlxG.mouse.visible = true;

	var changingAlpha:Bool = false;
	var scale:Float = 0.25;
	var w:Int = Std.int(bitmap.bitmapData.width * scale);
	var h:Int = Std.int(bitmap.bitmapData.height * scale);

	var preview:BitmapData = new BitmapData(w, h, true);
	var matrix:Matrix = new Matrix();
	matrix.scale(scale, scale);
	preview.draw(bitmap.bitmapData, matrix);

	var previewSprite = new Sprite();

	var onHover = function(e:MouseEvent) {
		trace('a');
		if (!changingAlpha)
			e.target.alpha = 0.6;
	};

	var onHoverOut = function(e:MouseEvent) {
		if (!changingAlpha)
			e.target.alpha = 1;
	}

	previewSprite.buttonMode = true;
	previewSprite.addEventListener(MouseEvent.MOUSE_DOWN, openScreenshotsFolder);
	previewSprite.addEventListener(MouseEvent.MOUSE_OVER, onHover);
	previewSprite.addEventListener(MouseEvent.MOUSE_OUT, onHoverOut);

	FlxG.stage.addChild(previewSprite);

	previewSprite.alpha = 0.0;
	previewSprite.y -= 10;

	var previewBitmap = new Bitmap(preview);
	previewSprite.addChild(previewBitmap);

	new FlxTimer().start(PREVIEW_INITIAL_DELAY, function(_) {
		changingAlpha = true;
		FlxTween.tween(previewSprite, {alpha: 1.0, y: 0}, PREVIEW_FADE_IN_DURATION, {
			ease: FlxEase.quartOut,
			onComplete: function(_) {
				changingAlpha = false;
				new FlxTimer().start(PREVIEW_FADE_OUT_DELAY, function(_) {
					changingAlpha = true;
					FlxTween.tween(previewSprite, {alpha: 0.0, y: 10}, PREVIEW_FADE_OUT_DURATION, {
						ease: FlxEase.quartInOut,
						onComplete: function(_) {
							previewSprite.removeEventListener(MouseEvent.MOUSE_DOWN, openScreenshotsFolder);
							previewSprite.removeEventListener(MouseEvent.MOUSE_OVER, onHover);
							previewSprite.removeEventListener(MouseEvent.MOUSE_OUT, onHoverOut);
							FlxG.stage.removeChild(previewSprite);
						}
					});
				});
			}
		});
	});
}

function openScreenshotsFolder(e:MouseEvent):Void {
	Sys.command('explorer', SCREENSHOT_FOLDER);
}

function encodePNG(bitmap:Bitmap):ByteArray {
	return bitmap.bitmapData.encode(bitmap.bitmapData.rect, new PNGEncoderOptions());
}

function saveScreenshot(bitmap:Bitmap) {
	makeScreenshotPath();
	var targetPath:String = getScreenshotPath();

	var pngData = encodePNG(bitmap);

	if (pngData == null) {
		trace('[WARN] Failed to encode PNG data.');
		return;
	} else {
		trace('Saving screenshot to: ' + targetPath);
		writeBytesToPath(targetPath, pngData);
	}
}

function getScreenshotPath():String {
	return SCREENSHOT_FOLDER + '/screenshot-' + getCaptureAmount() + '.png';
}

function getCaptureAmount():Void {
	FlxG.save.data.screenshotAmount = FlxG.save.data.screenshotAmount + 1;
	FlxG.save.flush();

	return FlxG.save.data.screenshotAmount;
}

function makeScreenshotPath():Void {
	createDirIfNotExists(SCREENSHOT_FOLDER);
}

function createDirIfNotExists(dir:String):Void {
	if (!FileSystem.exists(dir))
		FileSystem.createDirectory(dir);
}

function writeBytesToPath(path:String, data:Bytes):Void {
	createDirIfNotExists(Path.directory(path));

	if (!FileSystem.exists(path))
		File.saveBytes(path, data);
}
