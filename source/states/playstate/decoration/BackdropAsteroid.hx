package states.playstate.decoration;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class BackdropAsteroid extends FlxSprite {

  var floatSpeed: Float = 0;

  public function new(xLoc: Float, yLoc: Float, speed: Float) {
    super(xLoc, yLoc, "assets/asteroid.png");
    scale.set(1 - speed, 1 - speed);
    centerOrigin();
    solid = false;
    var value: Int = Math.round(Math.random() * 0xFF) | 0;
    color = FlxColor.fromRGB(value, value, value);
    floatSpeed = speed;
  }

  override public function update(elapsed: Float): Void {
    angle += 0.1;
    x -= floatSpeed;
    if (x < -width) {
      x = FlxG.width * 2;
    }
    super.update(elapsed);
  }

}
