package audio;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class Sounds {
  private static var instance: Sounds;
  private var soundFrontEnd: SoundFrontEnd;
  private var soundEffectGroup: FlxSoundGroup;
  private var chomp: FlxSound;
  private var chomp2: FlxSound;
  private var currentlyPlaying: FlxSound;

  private function new() {
    soundFrontEnd = FlxG.sound;
    soundEffectGroup = new FlxSoundGroup();

    chomp = soundFrontEnd.load(
      getChompAsset(),
      1,
      true,
      soundEffectGroup,
      false,
      false
    );
    chomp.volume = 1.0;
    chomp.time = 0;
    chomp.looped = false;
    chomp.loopTime = 0;
    soundEffectGroup.add(chomp);
    soundFrontEnd.cache(getChompAsset());

    chomp2 = soundFrontEnd.load(
      getChomp2Asset(),
      1,
      true,
      soundEffectGroup,
      false,
      false
    );
    chomp2.volume = 1.0;
    chomp2.time = 0;
    chomp2.looped = false;
    chomp2.loopTime = 0;
    soundEffectGroup.add(chomp2);
    soundFrontEnd.cache(getChomp2Asset());
  }

  private function playSound(sound: FlxSound): Void {
    sound.play(true);
    currentlyPlaying = sound;
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
