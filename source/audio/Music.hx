package audio;

import flixel.tweens.FlxTween;
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
    happyTheme.volume = 1.0;
    happyTheme.time = 1600;
    happyTheme.looped = true;
    happyTheme.loopTime = 4800;
    backgroundMusicGroup.add(happyTheme);
    soundFrontEnd.cache(getHappyThemeAsset());

    angryTheme = soundFrontEnd.load(
      getAngryThemeAsset(),
      1,
      true,
      backgroundMusicGroup,
      false,
      false
    );
    angryTheme.volume = 1.0;
    angryTheme.time = 1600;
    angryTheme.looped = true;
    angryTheme.loopTime = 4800;
    soundFrontEnd.cache(getAngryThemeAsset());
    backgroundMusicGroup.add(angryTheme);
  }

  private function playTheme(theme: FlxSound): Void {
    if (currentlyPlaying == null) {
      theme.play(false, theme.time);
    } else if (currentlyPlaying == theme) {
      // Let it play on, don't restart it.
    } else if (theme == instance.angryTheme) {
      currentlyPlaying.fadeOut(1, 0, startAngryTheme);
    } else if (theme == instance.happyTheme) {
      currentlyPlaying.fadeOut(1, 0, startHappyTheme);
    }
    currentlyPlaying = theme;
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
