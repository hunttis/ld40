package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.FlxAssets.FlxSoundAsset;
import music.Music;
import openfl.display.Sprite;
import states.PlayState;
import states.MainMenuState;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(800, 480, PlayState, 1, 60, 60, true));
    startMusic();
  }

  @:access(flixel.system.frontEnds.SoundFrontEnd)
  @:access(flixel.system.frontEnds.SoundFrontEnd.music)
  static public function startMusic():Void {
    var sound = FlxG.sound;
    trace("sound: " + sound);
    trace("Music: " + Music);

    // iloinen_teema_v1: FlxSoundAsset =

    // don't restart the music if it's already playing
    if (FlxG.sound.music == null) {
      FlxG.sound.playMusic("assets/music/iloinen_teema_v1.ogg", 1, true);
    }
  }
}