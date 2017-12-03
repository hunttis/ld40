package states.playstate.creature;

import flixel.FlxG;
import flixel.math.FlxVelocity;

class ReproductionBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.REPRODUCING;
  }

  public function init(creature: Creature) {
    creature.animation.play("loving");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    if (creature.targetCreature == null) {
      creature.findClosestReproducingCreature();
    } else {
      FlxVelocity.moveTowardsObject(creature, creature.targetCreature, 30);
      FlxG.overlap(creature, creature.targetCreature, function(self: Creature, other: Creature) {
        creature.reproduce();
        self.satisfaction = 0;
        other.satisfaction = 0;
        self.behavior = new IdleBehavior();
        other.behavior = new IdleBehavior();
      });
    }
  }
}