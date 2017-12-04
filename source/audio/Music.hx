package audio;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

class Music {
  private static var instance: Music;
  private var soundFrontEnd: SoundFrontEnd;
  private var backgroundMusicGroup: FlxSoundGroup;
  private var happyTheme: FlxSound;
  private var angryTheme: FlxSound;
  private var currentlyPlaying: FlxSound;
  private var mutex = false;

  private function new() {
    soundFrontEnd = FlxG.sound;
    backgroundMusicGroup = new FlxSoundGroup();

    happyTheme = soundFrontEnd.load(
      getHappyThemeAsset(),
      1,
      true,
      backgroundMusicGroup,
      false,
      false
    );
    resetTheme(happyTheme);
    soundFrontEnd.cache(getHappyThemeAsset());
    backgroundMusicGroup.add(happyTheme);

    angryTheme = soundFrontEnd.load(
      getAngryThemeAsset(),
      1,
      true,
      backgroundMusicGroup,
      false,
      false
    );
    resetTheme(angryTheme);
    soundFrontEnd.cache(getAngryThemeAsset());
    backgroundMusicGroup.add(angryTheme);
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
}
