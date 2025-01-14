import funkin.backend.MusicBeatState;

function postUpdate() {
    MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
    skipTransition = true;
    FlxG.switchState(new TitleState());
}