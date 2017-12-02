package states.playstate;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class SalesShip extends FlxSprite {

  var creatures: FlxTypedGroup<Creature>;

  var stateTimer: Float = 1;
  var salesPoint: FlxPoint;

  var state: SalesShipState;

  public function new(salesPoint: FlxPoint, creatures: FlxTypedGroup<Creature>) {
    super(salesPoint.x, -100);
    loadGraphic("assets/market_ship.png");
    this.salesPoint = salesPoint;
    this.creatures = creatures;
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

  function startCollecting(tween: FlxTween) {
    state = COLLECTING;
    stateTimer = 1;
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