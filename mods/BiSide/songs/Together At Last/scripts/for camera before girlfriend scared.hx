var customCameraPositionsEnabled = false;

function stepHit() {
    // Enable custom camera positions from step 255
    if (curStep == 255) {
        customCameraPositionsEnabled = true;
    }
}

function postUpdate() {
    // Only apply custom camera positions after they've been enabled
    if (customCameraPositionsEnabled) {
        if (curCameraTarget == 1) {
            camFollow.setPosition(900, 705);
        }
        if (curCameraTarget == 0) {
            camFollow.setPosition(700, 705); 
        }
    }
}