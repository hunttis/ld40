package;

import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.frontEnds.SoundFrontEnd;
import openfl.display.Sprite;
import states.PlayState;
import states.MainMenuState;

class Main extends Sprite {
  public function new() {
    super();
    startMusic();
    addChild(new FlxGame(800, 480, PlayState, 1, 60, 60, true));
  }

  @:access(flixel.system.frontEnds.SoundFrontEnd)
  @:access(flixel.system.frontEnds.SoundFrontEnd.music)
  static public function startMusic():Void {
    var sound: SoundFrontEnd = FlxG.sound;
    trace("sound: " + sound);
    // don't restart the music if it's already playing
    // if (FlxG.sound.music == null) {
    //   FlxG.sound.playMusic("assets/music/iloinen_teema_v1.mp3", 1, true);
    // }
  }
}