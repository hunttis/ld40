package states.playstate;

import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxColor;

class Weapon extends FlxNestedSprite {

  public function new() {
    super();
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  public function use(): Void {
    trace("Use weapon");
  }

}