package states.playstate.ship;

import flixel.math.FlxPoint;

class ImportShip extends Ship {

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint, gameLevel);
    waitMaximum = 5;
    stateTimer = waitMaximum;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  override function arrivedStartAction() {
      for (i in 0...3) {
        for (j in 0...3) {
          var newCreature: Creature = new Creature(shipLight.getGraphicMidpoint().x - 48 + i * 32, shipLight.getGraphicMidpoint().y - 48 + j * 32, gameLevel);
          creatures.add(newCreature);
        }
      }
  }

  override function arrivedContinuousAction(elapsed: Float) {
      
  }

}