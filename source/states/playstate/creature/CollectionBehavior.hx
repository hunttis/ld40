package states.playstate.creature;


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
  }
}
