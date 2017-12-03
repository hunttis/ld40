package music;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

@:build(flixel.system.FlxAssets.buildFileReferences("assets/music"))
class Music {
  var soundFrontEnd: SoundFrontEnd;
  var backgroundMusicGroup: FlxSoundGroup;
  var happyTheme: FlxSound;

  public function new() {
    soundFrontEnd = FlxG.sound;
    backgroundMusicGroup = new FlxSoundGroup();
    happyTheme = soundFrontEnd.load(
      iloinen_teema_v1__ogg,
      1,
      true,
      backgroundMusicGroup,
      false,
      false
    );
    soundFrontEnd.cache(iloinen_teema_v1__ogg);

  }

  @:access(flixel.system.frontEnds.SoundFrontEnd)
  @:access(flixel.system.frontEnds.SoundFrontEnd.music)
  static public function startMusic():Void {
    var sound = FlxG.sound;
    trace("sound: " + sound);
    trace("Music: " + Music);

    // don't restart the music if it's already playing
    if (FlxG.sound.music == null) {
      FlxG.sound.playMusic(iloinen_teema_v1__ogg, 1, true);
    }
  }
}
