package states.playstate.ship;

import states.playstate.creature.BehaviorType;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import states.playstate.creature.CollectionBehavior;

class SalesShip extends Ship {

  private var finishingLoading: Bool = false;
  public var hasVisited: Bool = false;

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint, gameLevel);
    waitMaximum = 120;
    stateTimer = waitMaximum;
  }

  override public function update(elapsed: Float): Void {

    if (state == ARRIVED) {
      tagCreatureForCollection();
    } else if (state == LEAVING) {
      var creaturesBeingCollected: Int = gameLevel.creatures.members.filter(function(creature) {
        return creature.alive && creature.behavior.getType() == BehaviorType.COLLECTED;
      }).length;

      if (creaturesBeingCollected == 0) {
        leaveAnimation();
        state = WAITING;
      }
    }

    super.update(elapsed);
  }

  function tagCreatureForCollection() {
    if (finishingLoading) {
      return;
    }
    var creature: Creature = findClosestCreature();
    if (creature != null) {
      creature.behavior = new CollectionBehavior();
      FlxTween.tween(creature, {x: shipLight.getGraphicMidpoint().x + Math.random() * 50 - 25, y: shipLight.getGraphicMidpoint().y + Math.random() * 50 - 25}, 1 + Math.random() * 2, {onComplete: creature.sell});
    }
  }

  public function findClosestCreature(): Creature {
    var closestCreature: Creature = null;
    var distance: Float = 100000;

    creatures.forEachAlive(function(creature) {
      var distanceToCreature: Float = FlxMath.distanceBetween(shipSprite, creature);
      if (distanceToCreature < 320 && creature.behavior.getType() != BehaviorType.COLLECTED && creature.behavior.getType() != BehaviorType.ANGRY && (closestCreature == null || distanceToCreature < distance)) {
        closestCreature = creature;
        distance = distanceToCreature;
      }
    });

    return closestCreature;
  }

  override public function leave() {
    state = LEAVING;
  }

}

