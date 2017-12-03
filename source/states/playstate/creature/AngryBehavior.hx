package states.playstate.creature;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;

class AngryBehavior implements Behavior {
  var route: Array<FlxPoint>;

  public function new() {}

  public function getType(): BehaviorType {
    return BehaviorType.ANGRY;
  }

  public function init(creature: Creature) {
    creature.animation.play("angry");
  }

  public function update(creature: Creature, elapsed: Float): Void {
    creature.hunger += elapsed;
    creature.velocity.set(0, 0);

    if (creature.hunger <= 2) {
      creature.behavior = new IdleBehavior();
    }

    if (creature.hunger <= 10) {
      creature.behavior = new HungryBehavior();
    }
    
    if (route == null) {
      findTarget(creature);
    } else {
      moveInRoute(creature);
    }

    FlxG.overlap(creature, creature.targetCreature, hurtTarget);
  }

  function hurtTarget(self: Creature, target: Creature) {
    self.hurt(0.4);
    target.hurt(1);
    self.targetCreature = null;
    route = null;
  }

  function moveInRoute(creature: Creature) {
    if (route != null) {
      var point = route[route.length-1];
      if (FlxMath.distanceToPoint(creature, point) < 5) {
        route.pop();
      } else {
        FlxVelocity.moveTowardsPoint(creature, point, 30);
      }
      if (route.length == 0) {
        route = null;
      }
      return;
    }
  }

  function findTarget(creature: Creature) {
    var closest = CreatureUtil.findClosestCreature(creature, creature.creatures);
    creature.targetCreature = closest;
    if (closest == null) {
      return;
    }
    var route = creature.tilemap.findPath(creature.getPosition(), closest.getPosition());
    route.reverse();
    this.route = route;
  }
}