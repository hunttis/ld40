package states.playstate.creature;

import flixel.math.FlxVelocity;
import flixel.FlxG;
import flixel.FlxG;

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

    if (creature.targetFood == null) {
      creature.checkForFood();
    } else {
      FlxVelocity.moveTowardsObject(creature, creature.targetFood, 50);
      FlxG.overlap(creature, creature.targetFood, function(self: Creature, food: Food) {
        food.hurt(0.1);
        creature.hunger = 0;
      });
    }
  }
}