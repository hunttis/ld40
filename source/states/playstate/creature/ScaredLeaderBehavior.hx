package states.playstate.creature;

import states.playstate.Creature;
import states.MathUtil;

class ScaredLeaderBehavior implements Behavior {
  public function new() {}

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug_lovin.png");
  }

  public function getType(): BehaviorType {
    return BehaviorType.SCARED_LEADER;
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.scareTime += elapsed;
    creature.velocity.set(0, 0);

    if (creature.scareTime > 5) {
      creature.scareTime = 0;
      creature.behavior = new IdleBehavior();
    }

    var farmer = creature.gameLevel.farmer;
    MathUtil.moveAwayFromObject(creature, farmer, 100);

    creature.scareClosestStableCreature();
  }
}