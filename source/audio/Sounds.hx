package audio;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class Sounds extends AudioSingleton<Sounds> {
  private static var instance: Sounds;
  private var chomp: FlxSound;
  private var chomp2: FlxSound;

  private function new() {
    super();
  }

  override private function loadSounds(): Void {
    chomp = loadSound(
      getChompAsset(),
      0.5,
      false,
      function onComplete(): Void {
        resetSoundProperties(chomp);
      }
    );
    chomp2 = loadSound(
      getChomp2Asset(),
      0.5,
      false,
      function onComplete(): Void {
        resetSoundProperties(chomp2);
      }
    );
  }

  override private function resetSoundProperties(sound: FlxSound): Void {
    sound.volume = 0.5;
    sound.time = 0;
    sound.looped = false;
    sound.loopTime = 0;
    sound.autoDestroy = false;
    sound.persist = true;
  }

  private function playSound(sound: FlxSound): Void {
    sound.play(true);
  }

  private static function getSoundEffectAsset(filename: String): FlxSoundAsset {
    #if flash
      return 'assets/sounds/$filename.mp3';
    #else
      return 'assets/sounds/$filename.ogg';
    #end
  }

  private static function getChompAsset(): FlxSoundAsset {
    return getSoundEffectAsset("chomp");
  }

  private static function getChomp2Asset(): FlxSoundAsset {
    return getSoundEffectAsset("chomp2");
  }

  static public function playChomp(): Void {
    if (instance == null) {
      instance = new Sounds();
    }
    instance.playSound(instance.chomp);
  }

  static public function playChomp2(): Void {
    if (instance == null) {
      instance = new Sounds();
    }
    instance.playSound(instance.chomp2);
  }
}
