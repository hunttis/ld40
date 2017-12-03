package states.playstate.creature;

import flixel.math.FlxPoint;

import states.playstate.Creature;
import states.MathUtil;

class ScaredLeaderBehavior implements Behavior {
  var directionSet: Bool = false;
  var escapeVelocity: FlxPoint = new FlxPoint(0, 0);
  
  public function new() {}

  public function init(creature: Creature) {
    creature.animation.play("loving");
  }

  public function getType(): BehaviorType {
    return BehaviorType.SCARED_LEADER;
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.scareTime += elapsed;
    creature.velocity.set(0, 0);

    if (creature.scareTime > 2) {
      creature.scareTime = 0;
      creature.behavior = new IdleBehavior();
    }

    if (!directionSet) {
      var farmer = creature.gameLevel.farmer;
      MathUtil.moveAwayFromObject(creature, farmer, 100);
      escapeVelocity.set(creature.velocity.x, creature.velocity.y);
      directionSet = true;
    } else {
      creature.velocity.set(escapeVelocity.x, escapeVelocity.y);
    }

    creature.scareClosestStableCreature();
  }
}