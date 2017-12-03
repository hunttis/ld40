package states.playstate.creature;

import flixel.math.FlxVelocity;
import flixel.FlxG;
import flixel.math.FlxMath;

class HungryBehavior implements Behavior {
  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.HUNGRY;
  }

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug_hungry.png");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    if (creature.hunger <= 2) {
      creature.behavior = new IdleBehavior();
    }

    if (creature.hunger > 10) {
      creature.behavior = new AngryBehavior();
    }

    if (creature.targetGrass == null) {
      creature.checkForFood();
    } else {
      FlxVelocity.moveTowardsPoint(creature, creature.targetGrass, 50);
      if (FlxMath.isDistanceToPointWithin(creature, creature.targetGrass, 1)) {
        creature.eatGrass();
      }
    }
  }
}