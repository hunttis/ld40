package states.playstate;

import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxColor;

class Food extends FlxNestedSprite {

  public function new(xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc);
    makeGraphic(16, 16, FlxColor.GREEN);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

}