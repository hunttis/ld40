package states.playstate.ship;

import flixel.math.FlxPoint;
import haxe.Timer;

class ImportShip extends Ship {

  public var hasVisited: Bool = false;

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint, gameLevel);
    waitMaximum = 30;
    stateTimer = waitMaximum;
    visitingTime = 1;
  }

  override public function update(elapsed: Float): Void {
    if (hasVisited) {
      return;
    }
    super.update(elapsed);
  }

  override function arrivedStartAction() {
    Timer.delay(dropCreatures, 400);
  }

  override function arrivedContinuousAction(elapsed: Float) {

  }

  override function visitedAction(): Void {
    hasVisited = true;
  }

  function dropCreatures() {
    for (i in 0...3) {
      for (j in 0...3) {
        var newCreature: Creature = new Creature(shipLight.getGraphicMidpoint().x - 48 + i * 32, shipLight.getGraphicMidpoint().y - 10 + j * 10, gameLevel);
        creatures.add(newCreature);
      }
    }
  }
}
