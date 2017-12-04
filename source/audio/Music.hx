package audio;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class Music extends AudioSingleton<Music> {
  private static var instance: Music;

  private var happyTheme: FlxSound;
  private var angryTheme: FlxSound;

  private var currentlyPlaying: FlxSound;
  private var mutex = false;

  override private function loadSounds(): Void {
    happyTheme = loadSound(
      getHappyThemeAsset(),
      true
    );
    angryTheme = loadSound(
      getAngryThemeAsset(),
      true
    );
  }

  override private function resetSoundProperties(sound: FlxSound): Void {
    sound.volume = 1.0;
    sound.time = 1600;
    sound.looped = true;
    sound.loopTime = 4800;
    sound.autoDestroy = false;
    sound.persist = true;
  }

  private function playSound(sound: FlxSound): Void {
    if (mutex == true) {
      return;
    }
    if (currentlyPlaying == null) {
      sound.play(true, 1600);
      currentlyPlaying = sound;
    } else if (currentlyPlaying == sound) {
      // Let it play on, don't restart it.
    } else {
      mutex = true;
      sound.play(true, 1600);
      currentlyPlaying.fadeOut(3.2, 0, function(_) {
        currentlyPlaying.stop();
        resetSoundProperties(currentlyPlaying);
        currentlyPlaying = sound;
        mutex = false;
      });
    }
  }

  private function stopSound(): Void {
    if (currentlyPlaying != null) {
      currentlyPlaying.fadeOut(3.2, 0, function(_) {
        currentlyPlaying.stop();
        resetSoundProperties(currentlyPlaying);
        currentlyPlaying = null;
      });
    }
  }

  private static function getMusicAsset(filename: String): FlxSoundAsset {
    #if flash
      return 'assets/music/$filename.mp3';
    #else
      return 'assets/music/$filename.ogg';
    #end
  }

  private static function getHappyThemeAsset(): FlxSoundAsset {
    return getMusicAsset("happy_theme_v1");
  }

  private static function getAngryThemeAsset(): FlxSoundAsset {
    return getMusicAsset("angry_theme_v1");
  }

  static public function playHappyTheme(): Void {
    if (instance == null) {
      instance = new Music();
    }
    instance.playSound(instance.happyTheme);
  }

  static public function playAngryTheme(): Void {
    if (instance == null) {
      instance = new Music();
    }
    instance.playSound(instance.angryTheme);
  }

  static public function stopMusic(): Void {
    if (instance == null) {
      instance = new Music();
    }
    instance.stopSound();
  }
}
