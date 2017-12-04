package audio;

import flixel.FlxG;
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
}
