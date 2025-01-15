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

function onCountdown(event) {
    // Augmenter la taille du compteur (Ready, Set, Go)
    var scaleFactor = 1.5; // Change cette valeur pour ajuster la taille
    event.scale = scaleFactor;

    // Garder le texte par défaut (sans chemin personnalisé)
    event.spritePath = switch(event.swagCounter) {
        case 0: null; // Rien pour 0
        case 1: 'game/ready'; // Ready
        case 2: 'game/set';   // Set
        case 3: 'game/go';    // Go
    };
}