package states.playstate;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
class Seed extends Item {

  public function new(xLoc: Float, yLoc: Float, gameLevel: GameLevel) {
    super(xLoc, yLoc, gameLevel);
    type = ItemType.SEED;
    loadGraphic("assets/seed.png");
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  public function landOnAsteroid(tween: FlxTween) {
    for (i in 1...10){
      var plop = new FlxSprite(getGraphicMidpoint().x - 8, getGraphicMidpoint().y - 8, "assets/plop.png");
      // plop.loadGraphic();
      plop.velocity.x = Math.random() * 200 - 100;
      plop.velocity.y = Math.random() * 200 - 100;
      gameLevel.temporaryLayer.add(plop);
    }
  }
}
