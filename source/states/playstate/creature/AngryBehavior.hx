package states.playstate.creature;

import flixel.FlxG;
import flixel.math.FlxVelocity;

class AngryBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.ANGRY;
  }

  public function init(creature: Creature) {
    creature.animation.play("angry");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    if (creature.hunger <= 2) {
      creature.behavior = new IdleBehavior();
    }

    if (creature.hunger <= 10) {
      creature.behavior = new HungryBehavior();
    }
    
    if (creature.targetCreature == null) {
      findTarget(creature);
    } else {
      moveTowardsTarget(creature);
    }

    FlxG.overlap(creature, creature.targetCreature, hurtTarget);
  }

  function hurtTarget(self: Creature, target: Creature) {
    self.hurt(0.4);
    target.hurt(1);
    self.targetCreature = null;
  }

  function moveTowardsTarget(creature: Creature) {
    if (creature.targetCreature != null) {
      FlxVelocity.moveTowardsObject(creature, creature.targetCreature, 60);
    }
  }

  function findTarget(creature: Creature) {
    var closest = CreatureUtil.findClosestCreature(creature, creature.creatures);
    creature.targetCreature = closest;
  }
}