package states.playstate.creature;

import states.playstate.Creature;

class ScaredFollowerBehavior implements Behavior {
  public function new() {}

  public function init(creature: Creature) {
    creature.animation.play("loving");
  }

  public function getType(): BehaviorType {
    return BehaviorType.SCARED_FOLLOWER;
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    creature.targetCreature = CreatureUtil.findClosestScaredLeader(creature, creature.creatures);

    if (creature.targetCreature != null) {
      creature.velocity.x = creature.targetCreature.velocity.x - 20;
      creature.velocity.y = creature.targetCreature.velocity.y - 20;
      creature.scareClosestStableCreature();
    } else {
      creature.behavior = new IdleBehavior();
    }
  }
}