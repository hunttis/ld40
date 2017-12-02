package states.playstate.creature;

class IdleBehavior implements Behavior {
  public function new() {}

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug.png");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    if (creature.hunger > 2) {
      creature.state = new HungryBehavior();
    }
  }
}