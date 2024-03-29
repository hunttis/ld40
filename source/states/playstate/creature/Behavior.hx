package states.playstate.creature;

interface Behavior {
  public function getType(): BehaviorType;
  public function init(creature: Creature): Void;
  public function update(creature: Creature, elapsed: Float): Void;
}
