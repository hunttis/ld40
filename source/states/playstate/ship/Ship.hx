package states.playstate.ship;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Ship extends FlxGroup {
  var stateTimer: Float = 1;
  var state: ShipState;
  var creatures: FlxTypedGroup<Creature>;
  var landingPoint: FlxPoint;
  var gameLevel: GameLevel;

  var shipSprite: FlxSprite;
  public var shipLight: FlxSprite;
  var shipBeam: FlxSprite;

  public var arrivalCounter: Float = 0;
  public var visitingTime: Float = 10;
  public var waitMaximum: Float = 0;

  public function new(landingPoint: FlxPoint, gameLevel: GameLevel) {
    super();

    shipBeam = new FlxSprite(landingPoint.x, landingPoint.y);
    shipBeam.visible = false;
    shipBeam.loadGraphic("assets/ship_beam.png");
    shipBeam.centerOrigin();
    add(shipBeam);

    shipSprite = new FlxSprite(landingPoint.x, -300);
    shipSprite.loadGraphic("assets/market_ship.png");
    add(shipSprite);

    shipLight = new FlxSprite(landingPoint.x, landingPoint.y);
    shipLight.loadGraphic("assets/ship_light.png");
    shipLight.alpha = 0;
    shipLight.scale.set(3, 3);
    add(shipLight);

    this.landingPoint = landingPoint;
    this.creatures = gameLevel.creatures;
    this.gameLevel = gameLevel;
    state = WAITING;
  }

  override public function update(elapsed: Float): Void {
    stateTimer -= elapsed;

    if (state == WAITING && stateTimer < 0) {
      state = ARRIVING;
      stateTimer = 1;
      // FlxTween.tween(this, {y: 0, x: 0}, 1, {ease: FlxEase.quintOut});
      FlxTween.tween(shipSprite, {y: landingPoint.y - shipSprite.origin.y - 100}, 1, {ease: FlxEase.quintOut});
      FlxTween.tween(shipLight, {alpha: 0.3}, 1, {ease: FlxEase.quintOut});
      FlxTween.tween(shipLight.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quintOut});
    } else if (state == ARRIVING && stateTimer < 0) {
      state = ARRIVED;
      stateTimer = visitingTime;
      shipBeam.x = shipSprite.x + 32;
      shipBeam.y = shipSprite.y + 130;
      shipBeam.visible = true;
      shipBeam.alpha = 0.0;
      FlxTween.tween(shipBeam, {alpha: 0.5}, 0.3, {ease: FlxEase.quadIn});
      arrivedStartAction();
    } else if (state == ARRIVED && stateTimer > 0) {
      arrivedContinuousAction(elapsed);
    } else if (state == ARRIVED && stateTimer < 0) {
      FlxTween.tween(shipBeam, {alpha: 0}, 0.3, {ease: FlxEase.quadIn, onComplete: disableBeam});
      state = LEAVING;
      stateTimer = 1;
      FlxTween.tween(shipSprite, {y: -300}, 1, {ease: FlxEase.quadIn});
      FlxTween.tween(shipLight, {alpha: 0}, 1, {ease: FlxEase.quadIn});
      FlxTween.tween(shipLight.scale, {x: 3, y: 3}, 1, {ease: FlxEase.quintIn});
    } else if (state == LEAVING && stateTimer < 0) {
      visitedAction();
      state = WAITING;
      stateTimer = waitMaximum;
    }

    arrivalCounter = getArrival();

    super.update(elapsed);
  }

  function disableBeam(tween: FlxTween) {
    shipBeam.visible = false;
  }

  function arrivedStartAction(): Void {
    // TODO @kukko: Is this a bug?
    Sys.stderr("THIS SHIP DOES NOTHING ON ARRIVAL!");
  }

  function arrivedContinuousAction(elapsed: Float): Void {
    // TODO @kukko: Is this a bug?
    Sys.stderr("ARRIVED STATE NOT IMPLEMENTED!");
  }

  public function getArrival(): Float {
    if (state == WAITING) {
      return stateTimer;
    } else {
      return 0;
    }
  }

  public function visitedAction(): Void {}
}
