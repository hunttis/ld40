package states.playstate.creature;

class IdleBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.IDLE;
  }

  public function init(creature: Creature) {
    creature.animation.play("idle");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.satisfaction += elapsed;
    // creature.velocity.set(0, 0);

    if (creature.hunger > Creature.HUNGRY_LIMIT) {
      creature.behavior = new HungryBehavior();
      creature.satisfaction = 0;
    }
    if (creature.satisfaction > 5) {
      creature.behavior = new ReproductionBehavior();
    }

    creature.separate();
  }
}
