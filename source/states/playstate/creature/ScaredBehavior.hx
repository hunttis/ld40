package states.playstate.creature;

import states.playstate.Creature;

class ScaredBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.SCARED;
  }

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug.png");
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
  }
}