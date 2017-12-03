package states.playstate;

import flixel.util.FlxColor;

class Food extends Item {

  public function new(xLoc: Float, yLoc: Float, gameLevel: GameLevel) {
    super(xLoc, yLoc, gameLevel);
    loadGraphic("assets/food.png");
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

}