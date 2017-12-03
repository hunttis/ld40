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

    if (creature.hunger > Creature.CANNIBAL_DEATH_LIMIT) {
      creature.kill();
    }
    
    var target = creature.targetCreature;
    if (target == null || !target.alive || target.behavior.getType() == BehaviorType.ANGRY) {
      findTarget(creature);
    } else {
      moveTowardsTarget(creature);
    }

    FlxG.overlap(creature, creature.targetCreature, hurtTarget);
  }

  function hurtTarget(self: Creature, target: Creature) {
    target.hurt(1);
    self.scale.add(0.05, 0.05);
    self.targetCreature = null;
  }

  function moveTowardsTarget(creature: Creature) {
    if (creature.targetCreature != null) {
      FlxVelocity.moveTowardsObject(creature, creature.targetCreature, 60);
    }
  }

  function findTarget(creature: Creature) {
    var closest = CreatureUtil.findClosestCreatureWith(creature, creature.creatures, function(creature) return creature.behavior.getType() != BehaviorType.ANGRY);
    creature.targetCreature = closest;
  }
}