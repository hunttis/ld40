package states.playstate.creature;

import flixel.FlxG;
import flixel.math.FlxVelocity;
class CollectionBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.COLLECTED;
  }

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug.png");
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
    creature.kill();
  }
}