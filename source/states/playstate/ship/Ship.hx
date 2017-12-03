package states.playstate.ship;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Ship extends FlxSprite {

  var stateTimer: Float = 1;
  var state: ShipState;
  var creatures: FlxTypedGroup<Creature>;
  var landingPoint: FlxPoint;
  var gameLevel: GameLevel;

  public var arrivalCounter: Float = 0;
  public var waitMaximum: Float = 0;

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super(landingPoint.x, -100);
    loadGraphic("assets/market_ship.png");
    this.landingPoint = landingPoint;
    this.creatures = gameLevel.creatures;
    this.gameLevel = gameLevel;
    state = WAITING;
  }

  override public function update(elapsed: Float): Void {
    stateTimer -= elapsed;

    if (state == WAITING && stateTimer < 0) {
      trace("Ship arriving!");
      state = ARRIVING;
      stateTimer = 1;
      FlxTween.tween(this, {y: landingPoint.y}, 1, {ease: FlxEase.quintOut});
    } else if (state == ARRIVING && stateTimer < 0) {
      trace("Ship arrived!");
      state = ARRIVED;
      stateTimer = 10;
      arrivedStartAction();
    } else if (state == ARRIVED && stateTimer > 0) {
      arrivedContinuousAction(elapsed);
    } else if (state == ARRIVED && stateTimer < 0) {
      trace("Ship leaving!");
      state = LEAVING;
      stateTimer = 1;
      FlxTween.tween(this, {y: -100}, 1, {ease: FlxEase.quadIn});
    } else if (state == LEAVING && stateTimer < 0) {
      trace("Ship left, waiting..");
      state = WAITING;
      stateTimer = waitMaximum;
    }

    arrivalCounter = getArrival();

    super.update(elapsed);
  }

  function arrivedStartAction(): Void {
    trace("THIS SHIP DOES NOTHING ON ARRIVAL!");
  }

  function arrivedContinuousAction(elapsed: Float): Void {
    trace("ARRIVED STATE NOT IMPLEMENTED!");
  }

  public function getArrival(): Float {
    if (state == WAITING) {
      trace("returning stateTimer: " + stateTimer);
      return stateTimer;
    } else {
      trace("Not waiting: " + state);
      return 0;
    }
  }

}