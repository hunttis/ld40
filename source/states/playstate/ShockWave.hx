package states.playstate;

import flixel.FlxSprite;

class ShockWave extends FlxSprite {

  public function new(xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc);
    loadGraphic("assets/bam.png");
  }

  override public function update(elapsed) {
    this.hurt(0.1);
    this.scale.add(1, 1);
    this.alpha = this.health;
    super.update(elapsed);
  }
}