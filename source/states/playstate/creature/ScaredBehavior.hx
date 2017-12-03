package states.playstate.creature;

import states.playstate.Creature;

class ScaredBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.SCARED;
  }

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug_lovin.png");
  }

  public function update(creature: Creature, elapsed: Float): Void {}
}