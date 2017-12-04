package audio;

import flixel.tweens.FlxTween;
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

  private function new() {
    super();
  }

  override private function loadSounds(): Void {
    happyTheme = soundFrontEnd.load(
      getHappyThemeAsset(),
      1,
      true,
      soundGroup,
      false,
      false
    );
    resetTheme(happyTheme);
    soundFrontEnd.cache(getHappyThemeAsset());
    soundGroup.add(happyTheme);

    angryTheme = soundFrontEnd.load(
      getAngryThemeAsset(),
      1,
      true,
      soundGroup,
      false,
      false
    );
    resetTheme(angryTheme);
    soundFrontEnd.cache(getAngryThemeAsset());
    soundGroup.add(angryTheme);
  }

  private function playTheme(theme: FlxSound): Void {
    if (mutex == true) {
      return;
    }
    if (currentlyPlaying == null) {
      theme.play(true, 1600);
      currentlyPlaying = theme;
    } else if (currentlyPlaying == theme) {
      // Let it play on, don't restart it.
    } else {
      mutex = true;
      theme.play(true, 1600);
      currentlyPlaying.fadeOut(1.6, 0, function(_) {
        currentlyPlaying.stop();
        resetTheme(currentlyPlaying);
        currentlyPlaying = theme;
        mutex = false;
      });
    }
  }

  private function stopMusic(): Void {
    if (currentlyPlaying != null) {
      currentlyPlaying.fadeOut(1.6, 0, function(_) {
        currentlyPlaying.stop();
        resetTheme(currentlyPlaying);
        currentlyPlaying = null;
      });
    }
  }

  private static function startAngryTheme(tween: FlxTween) {
    instance.angryTheme.volume = 1.0;
    instance.angryTheme.play(false, instance.angryTheme.time);
  }

  private static function startHappyTheme(tween: FlxTween) {
    instance.happyTheme.volume = 1.0;
    instance.happyTheme.play(false, instance.happyTheme.time);
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

  private static function resetTheme(theme: FlxSound): Void {
    theme.volume = 1.0;
    theme.time = 1600;
    theme.looped = true;
    theme.loopTime = 4800;
    theme.autoDestroy = false;
    theme.persist = true;
  }

  static public function playHappyTheme(): Void {
    if (instance == null) {
      instance = new Music();
    }
    instance.playTheme(instance.happyTheme);
  }

  static public function playAngryTheme(): Void {
    if (instance == null) {
      instance = new Music();
    }
    instance.playTheme(instance.angryTheme);
  }

  static public function stop(): Void {
    if (instance == null) {
      instance = new Music();
    }
    instance.stopMusic();
  }
}
