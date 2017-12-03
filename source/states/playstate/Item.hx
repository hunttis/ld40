package states.playstate;

import flixel.addons.display.FlxNestedSprite;

class Item extends FlxNestedSprite {

  var gameLevel: GameLevel;

  public function new(xLoc: Float, yLoc: Float, gameLevel: GameLevel) {
    super(xLoc, yLoc);
    this.gameLevel = gameLevel;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  public function use(): Void {}
}