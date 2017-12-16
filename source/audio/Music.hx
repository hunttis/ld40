package audio;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class Music extends AudioSingleton<Music> {
  private static var singleton: Music;

  private var happyTheme: FlxSound;
  private var angryTheme: FlxSound;
  private var mainMenuTheme: FlxSound;

  private var currentlyPlaying: FlxSound;
  private var mutex = false;

  override private function loadSounds(): Void {
    happyTheme = loadSound(
      asset("happy_theme_v1"),
      true
    );
    angryTheme = loadSound(
      asset("angry_theme_v1"),
      true
    );
    mainMenuTheme = loadSound(
      asset("choir_theme_v3"),
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

  override private function assetPath(): String {
    return "assets/music";
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

  public static function instance(): Music {
    if (singleton == null) {
      singleton = new Music();
    }
    return singleton;
  }

  public static function playMainMenuTheme(): Void {
    instance().playSound(instance().mainMenuTheme);
  }

  public static function playHappyTheme(): Void {
    instance().playSound(instance().happyTheme);
  }

  public static function playAngryTheme(): Void {
    instance().playSound(instance().angryTheme);
  }

  public static function stopMusic(): Void {
    instance().stopSound();
  }
}
