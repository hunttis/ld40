package states.playstate.ship;

import states.playstate.creature.BehaviorType;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import states.playstate.creature.CollectionBehavior;

class SalesShip extends Ship {

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint, gameLevel);
    stateTimer = 10;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  function tagCreatureForCollection() {
    var creature: Creature = findClosestCreature();
    if (creature != null) {
      creature.behavior = new CollectionBehavior();
      FlxTween.tween(creature, {x: this.getGraphicMidpoint().x, y: this.getGraphicMidpoint().y }, 3);
    }
  }

  public function findClosestCreature(): Creature {
    var closestCreature: Creature = null;
    var distance: Float = 100000;

    creatures.forEachAlive(function(creature) {
      var distanceToCreature: Float = FlxMath.distanceBetween(this, creature);
      if (creature.behavior.getType() != BehaviorType.COLLECTED && creature.behavior.getType() != BehaviorType.ANGRY && (closestCreature == null || distanceToCreature < distance)) {
        closestCreature = creature;
        distance = distanceToCreature;
      }
    });
    
    return closestCreature;
  }

  override function arrivedStateAction(elapsed: Float) {
    tagCreatureForCollection();
  }

}

