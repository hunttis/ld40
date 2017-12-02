package states.playstate;

import states.playstate.creature.BehaviorType;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import states.playstate.creature.CollectionBehavior;

class SalesShip extends FlxSprite {

  var creatures: FlxTypedGroup<Creature>;
  var creaturesInTransit: Array<Creature>;

  var stateTimer: Float = 1;
  var salesPoint: FlxPoint;

  var state: SalesShipState;

  public function new(salesPoint: FlxPoint, creatures: FlxTypedGroup<Creature>) {
    super(salesPoint.x, -100);
    loadGraphic("assets/market_ship.png");
    centerOrigin();
    this.salesPoint = salesPoint;
    this.creatures = creatures;
    creaturesInTransit = new Array<Creature>();
    state = WAITING;
  }

  override public function update(elapsed: Float): Void {
    stateTimer -= elapsed;

    if (state == WAITING && stateTimer < 0) {
      trace("Ship arriving!");
      state == ARRIVING;
      stateTimer = 1;
      FlxTween.tween(this, {y: salesPoint.y}, 1, {ease: FlxEase.quintOut, onComplete: startCollecting});
    } else if (state == COLLECTING && stateTimer > 0) {
      trace("Ship collecting!");
      tagCreatureForCollection();
    } else if (state == COLLECTING && stateTimer < 0) {
      state == LEAVING;
      stateTimer = 1;
      FlxTween.tween(this, {y: -100}, 1, {ease: FlxEase.quadIn, onComplete: startWaiting});
    } else if (state == LEAVING && stateTimer < 0) {
      state == WAITING;
      stateTimer = 1;
    }
    
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

  function startCollecting(tween: FlxTween) {
    state = COLLECTING;
    stateTimer = 10;
  }

  function startWaiting(tween: FlxTween) {
    state = WAITING;
    stateTimer = 1;
  }

}

enum SalesShipState {
  WAITING;
  ARRIVING;
  COLLECTING;
  LEAVING;
}