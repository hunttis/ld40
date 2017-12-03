package states.playstate.decoration;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class BackdropAsteroid extends FlxSprite {

  public function new(xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc, "assets/asteroid.png");
    solid = false;
    color = FlxColor.GRAY;
  }

  override public function update(elapsed: Float): Void {
    angle += 0.1;
    x -= 1;
    super.update(elapsed);
  }

}