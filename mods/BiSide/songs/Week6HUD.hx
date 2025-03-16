function postCreate() {
    var newFont = Paths.font("MPLUSRounded1c-Black.ttf");
    
    // Apply font to common HUD elements
    if (newFont != null) {
        scoreTxt.font = newFont;
        missesTxt.font = newFont;
        accuracyTxt.font = newFont;
    }
}