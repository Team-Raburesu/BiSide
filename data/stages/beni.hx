import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import funkin.backend.shaders.FunkinShader;
function postCreate() {
    var i = 0;
    for(c in [boyfriend, dad]) {
        i++;

        c.shader = new CustomShader("shadow");
        c.shader.color = [1.6, 280 / 255, 0, 0.33 * ((3 - i) / 2)];
        c.shader.shadowLength = 45 * ((3 - i) / 2);
        c.shader.flipped = c.flipX;
		c.shader.blend = 0;
    }
bloomShader = new FunkinShader(Assets.getText(Paths.fragShader("bloom")));
            FlxG.camera.addShader(bloomShader); 

}