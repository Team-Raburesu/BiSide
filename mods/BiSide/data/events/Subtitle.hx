var curCharacter:Character = null;

function onEvent(e) {
    if (e.event.name == "Character Switch") {
        var params = e.event.params;
        var charName = params[0];
        var xPos = params[1];
        var yPos = params[2];
        
        // Remove existing custom character if it exists
        if (curCharacter != null) {
            remove(curCharacter);
            curCharacter.destroy();
        }
        
        // Create new character
        curCharacter = new Character(xPos, yPos, charName);
        add(curCharacter);
        
        // Update boyfriend reference and camera
        PlayState.instance.boyfriend = curCharacter;
        PlayState.instance.cameraController.character = curCharacter;
        PlayState.instance.cameraController.recalculatePosition();
    }
}