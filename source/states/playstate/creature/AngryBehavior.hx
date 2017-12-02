package states.playstate.creature;

import flixel.FlxG;
import flixel.math.FlxVelocity;

class AngryBehavior implements Behavior {
  public function new() {}

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug_angry.png");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    if (creature.hunger <= 2) {
      creature.state = new IdleBehavior();
    }

    if (creature.hunger <= 10) {
      creature.state = new HungryBehavior();
    }

    if (creature.targetCreature == null) {
      creature.findClosestCreature();
    } else {
      FlxVelocity.moveTowardsObject(creature, creature.targetCreature, 30);
      FlxG.overlap(creature, creature.targetCreature, function(self: Creature, other: Creature) {
        other.hurt(0.1);
        if (!other.alive) {
          creature.targetCreature = null;
        }
      });
    }
  }
}