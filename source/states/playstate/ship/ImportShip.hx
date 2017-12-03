package states.playstate.ship;

import flixel.math.FlxPoint;

class ImportShip extends Ship {

  var unloadCounter: Float = 0;

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint, gameLevel);
    waitMaximum = 30;
    stateTimer = waitMaximum;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  override function arrivedStartAction() {
    unloadCounter = 10;
  }

  override function arrivedContinuousAction(elapsed: Float) {
    if (unloadCounter > 0) {
      var newCreature: Creature = new Creature(landingPoint.x + Math.random() * 100 - 50, landingPoint.y + Math.random() * 100 - 50, gameLevel);
      creatures.add(newCreature);
      unloadCounter--;
    }
  }

}