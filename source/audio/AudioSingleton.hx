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

  private function loadSounds(): Void {}

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

  private function resetSoundProperties(sound: FlxSound): Void {}
}
