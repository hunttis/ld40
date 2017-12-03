package music;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;

@:build(flixel.system.FlxAssets.buildFileReferences("assets/music"))
class Music {
  @:access(flixel.system.frontEnds.SoundFrontEnd)
  @:access(flixel.system.frontEnds.SoundFrontEnd.music)
  static public function startMusic():Void {
    var sound = FlxG.sound;
    trace("sound: " + sound);
    trace("Music: " + Music);

    // iloinen_teema_v1: FlxSoundAsset =

    // don't restart the music if it's already playing
    if (FlxG.sound.music == null) {
      FlxG.sound.playMusic("assets/music/iloinen_teema_v1.ogg", 1, true);
    }
  }
}
