package states.playstate.creature;

import states.playstate.Creature;

class ScaredFollowerBehavior extends ScaredBehavior {
  public function new() {super()}

  override public function getType(): BehaviorType {
    return BehaviorType.SCARED;
  }

  override public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    if (creature.hunger <= 2) {
      creature.behavior = new IdleBehavior();
    }

    if (creature.hunger <= 10) {
      creature.behavior = new HungryBehavior();
    }
  }
}