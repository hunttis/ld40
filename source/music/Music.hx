package music;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import flixel.system.frontEnds.SoundFrontEnd;

@:build(flixel.system.FlxAssets.buildFileReferences("assets/music"))
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
    } else {
      currentlyPlaying.fadeOut(1000, 0, function(_) {
        theme.play(false, theme.time);
      });
    }
    currentlyPlaying = theme;
  }

  private static function getHappyThemeAsset(): FlxSoundAsset {
    #if flash
      return happy_theme_v1__mp3;
    #else
      return happy_theme_v1__ogg;
    #end
  }

  private static function getAngryThemeAsset(): FlxSoundAsset {
    #if flash
      return angry_theme_v1__mp3;
    #else
      return angry_theme_v1__ogg;
    #end
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
