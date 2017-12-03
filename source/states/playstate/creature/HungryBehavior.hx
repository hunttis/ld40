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
    creature.animation.play("hungry");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    creature.eatGrass();

    if (creature.hunger <= Creature.HUNGRY_LIMIT) {
      creature.behavior = new IdleBehavior();
    }

    if (creature.hunger > Creature.ANGRY_LIMIT) {
      creature.behavior = new AngryBehavior();
    }

    if (creature.targetGrass == null || !creature.isTargetGrassEatable()) {
      creature.checkForFood();
    } else {
      creature.moveTowards(creature.targetGrass.x, creature.targetGrass.y, 50);
    }
  }
}