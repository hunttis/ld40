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
    creature.targetCreature = CreatureUtil.findClosestReproducingCreature(creature, creature.creatures);
    if (creature.targetCreature != null) {
      FlxVelocity.moveTowardsObject(creature, creature.targetCreature, 60);
      FlxG.overlap(creature, creature.targetCreature, function(self: Creature, other: Creature) {
        creature.reproduce();
        creature.targetCreature.reproduce();
        self.satisfaction = 0;
        other.satisfaction = 0;
        self.behavior = new IdleBehavior();
        other.behavior = new IdleBehavior();
      });
    }
  }
}