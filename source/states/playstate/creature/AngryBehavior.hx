package states.playstate.creature;

import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;

class AngryBehavior implements Behavior {
  var route: Array<FlxPoint>;

  public function new() {}

  public function init(creature: Creature) {
    creature.loadGraphic("assets/bug_angry.png");
    findTarget(creature);
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

    moveInRoute(creature);
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
    var closest = creature.findClosestCreature();
    if (closest == null) {
      return;
    }
    var route = creature.tilemap.findPath(creature.getPosition(), closest.getPosition());
    route.reverse();
    this.route = route;
  }
}