package audio;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class Sounds extends AudioSingleton<Sounds> {
  private static var singleton: Sounds;

  private var chomp: FlxSound;
  private var chomp2: FlxSound;

  override private function loadSounds(): Void {
    chomp = loadSound(
      asset("chomp"),
      0.5,
      false
    );
    chomp2 = loadSound(
      asset("chomp2"),
      0.5,
      false
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

  override private function assetPath(): String {
    return "assets/sounds";
  }

  private function playSound(sound: FlxSound): Void {
    sound.onComplete = function() {
      resetSoundProperties(sound);
    };
    sound.play(true);
  }

  public static function instance(): Sounds {
    if (singleton == null) {
      singleton = new Sounds();
    }
    return singleton;
  }

  public static function playChomp(): Void {
    instance().playSound(instance().chomp);
  }

  public static function playChomp2(): Void {
    instance().playSound(instance().chomp2);
  }
}
