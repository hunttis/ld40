package states.playstate.creature;

import flixel.FlxG;
import flixel.math.FlxVelocity;
import states.playstate.ship.SalesShip;

class CollectionBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.COLLECTED;
  }

  public function init(creature: Creature) {
    creature.animation.play("idle");
    creature.solid = false;
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.angle += 1;
    creature.solid = true;
    FlxG.overlap(creature, creature.gameLevel.salesShip, creatureCollidesSales);
    creature.solid = false;
  }

  function creatureCollidesSales(creature: Creature, salesShip: SalesShip) {
    trace("Creature hitting collector!");
    creature.sell();
  }
}
