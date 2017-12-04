package states.playstate.ship;

import states.playstate.creature.IdleBehavior;
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
    
    if (state == ARRIVED && stateTimer < 1) {
      finishingLoading = true;
    }

    if (state == ARRIVED) {
      trace("Sales Ship: " + finishingLoading + " - " + state + " - " + stateTimer);
    }

    for (creature in gameLevel.creatures.members) {
      if (finishingLoading && state == ARRIVED && creature.alive && creature.behavior.getType() == BehaviorType.COLLECTED && stateTimer < 1) {
        stateTimer = 1;
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
      FlxTween.tween(creature, {x: shipSprite.getGraphicMidpoint().x, y: shipSprite.getGraphicMidpoint().y }, 3);
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

  override function arrivedContinuousAction(elapsed: Float) {
    tagCreatureForCollection();
  }

  override function visitedAction() {
    hasVisited = true;
  }

}

