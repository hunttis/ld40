package audio;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class AudioSingleton<T> {
  private var soundFrontEnd: SoundFrontEnd;
  private var soundGroup: FlxSoundGroup;

  private function new() {
    soundFrontEnd = FlxG.sound;
    soundGroup = new FlxSoundGroup();
    loadSounds();
  }

  private function loadSounds(): Void {
    throw '"Abstract" function "loadSounds()" not implemented.';
  }

  private function loadSound(
    asset: FlxSoundAsset,
    Volume: Float = 1,
    Looped: Bool = false,
    ?URL: String,
    ?OnComplete: Void -> Void): FlxSound {
    var sound: FlxSound = soundFrontEnd.load(
      asset,
      Volume,
      Looped,
      soundGroup,
      false,
      false,
      URL,
      OnComplete
    );
    resetSoundProperties(sound);
    soundGroup.add(sound);
    soundFrontEnd.cache(asset);
    return sound;
  }

  private function resetSoundProperties(sound: FlxSound): Void {
    throw '"Abstract" function "resetSoundProperties(sound: FlxSound)" not implemented.';
  }

  private function assetPath(): String {
    throw '"Abstract" function "assetPath()" not implemented.';
  }

  private function asset(filename: String): FlxSoundAsset {
    #if flash
      return '${assetPath()}/$filename.mp3';
    #else
      return '${assetPath()}/$filename.ogg';
    #end
  }
}
