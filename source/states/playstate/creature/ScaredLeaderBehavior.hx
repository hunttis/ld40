package states.playstate.creature;

import states.playstate.Creature;
import states.MathUtil;

class ScaredLeaderBehavior extends ScaredBehavior {
  public function new() {super();}

  override public function getType(): BehaviorType {
    return BehaviorType.SCARED_LEADER;
  }

  override public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.scareTime += elapsed;
    creature.velocity.set(0, 0);

    if (creature.scareTime > 5) {
      creature.behavior = new IdleBehavior();
    }
    if (creature.hunger > 20) {
      creature.behavior = new AngryBehavior();
    }

    var farmer = creature.gameLevel.farmer;

    MathUtil.moveAwayFromObject(creature, farmer, 60);
  }
}