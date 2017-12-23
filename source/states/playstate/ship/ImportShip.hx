package states.playstate.ship;

import flixel.math.FlxPoint;
import haxe.Timer;

class ImportShip extends Ship {

  public var hasVisited: Bool = false;

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint, gameLevel);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  override function arrivedAction() {
    Timer.delay(dropCreatures, 400);
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
