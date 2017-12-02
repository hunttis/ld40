package states.playstate;

import flixel.addons.display.FlxNestedSprite;

class Item extends FlxNestedSprite {

  public function new(xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  public function use(): Void {}
}