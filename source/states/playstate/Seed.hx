package states.playstate;

class Seed extends Item {
  public function new(xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc, gameLevel);
    type = ItemType.SEED;
    loadGraphic("assets/food.png");
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }
}