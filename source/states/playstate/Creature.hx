package states.playstate;

import flixel.util.FlxSpriteUtil;
import flixel.addons.display.FlxNestedSprite;
import states.playstate.creature.BehaviorType;
import flixel.tile.FlxTilemap;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import states.playstate.creature.Behavior;
import states.playstate.creature.IdleBehavior;
import states.playstate.creature.ScaredLeaderBehavior;
import states.playstate.creature.ScaredFollowerBehavior;
import states.playstate.creature.CreatureUtil;
import flixel.math.FlxVector;

class Creature extends FlxNestedSprite {

  public static var HUNGRY_LIMIT: Float = 4;
  public static var ANGRY_LIMIT: Float = 15;
  public static var CANNIBAL_DEATH_LIMIT: Float = 30;

  public var hunger: Float = 0;
  public var satisfaction: Float = 0;
  public var scareTime: Float = 0;

  public var targetGrass: FlxPoint;
  public var targetCreature: Creature;
  public var tilemap: FlxTilemap;

  var foods: FlxTypedGroup<Food>;
  public var creatures: FlxTypedGroup<Creature>;
  public var behavior(default, set): Behavior;
  var separation = new FlxVector(0.0, 0.0);
  var targetDirVector = new FlxVector(0.0, 0.0);

  public var gameLevel: GameLevel;

  public function new(xLoc: Float, yLoc: Float, gameLevel: GameLevel) {
    super(xLoc, yLoc);

    loadGraphic("assets/bugs.png", true, 32, 32);
    animation.add("idle", [0], 1, false);
    animation.add("hungry", [1], 1, false);
    animation.add("loving", [2], 1, false);
    animation.add("angry", [3], 1, false);


    this.gameLevel = gameLevel;
    this.tilemap = gameLevel.levelMap.foregroundLayer;

    behavior = new IdleBehavior();
    this.foods = gameLevel.items.foods;
    this.creatures = gameLevel.creatures;
    this.offset.y = 24;
    this.height = 8;
    // solid = false;

    var shadow = new FlxNestedSprite(xLoc, yLoc, "assets/shadow.png");
    shadow.relativeX = 0;
    shadow.relativeY = 28;
    shadow.solid = false;
    add(shadow);
  }

  public function set_behavior(nextBehavior: Behavior) {
    nextBehavior.init(this);
    return behavior = nextBehavior;
  }

  override public function update(elapsed: Float) {
    velocity.x = 0;
    velocity.y = 0;

    behavior.update(this, elapsed);

    super.update(elapsed);

    FlxSpriteUtil.bound(this, 0, 1600, 0, 640);
  }

  public function checkForFood(): Void {
    var pos = tileCoords();
    var grass = gameLevel.grass.findNearEatableGrass(Math.round(pos.x), Math.round(pos.y));
    targetGrass = grass;
    pos.put();
  }

  public function eatGrass(): Void {
    var coords = tileCoords();
    var satiation = gameLevel.grass.eatGrass(Math.round(coords.x), Math.round(coords.y));
    coords.put();
    this.hunger -= satiation;
    if (this.targetGrass != null && FlxMath.isDistanceToPointWithin(this, this.targetGrass, 10)) {
      this.targetGrass = null;
    }
  }

  function tileCoords(): FlxPoint {
    var pos = getGraphicMidpoint();
    var index = gameLevel.levelMap.grassLayer.getTileIndexByCoords(pos);
    var width = gameLevel.levelMap.grassLayer.widthInTiles;
    var x = Math.floor(index % width);
    var y = Math.floor(index / width);
    return FlxPoint.get(x, y);
  }

  public function isTargetGrassEatable(): Bool {
    return gameLevel.grass.isGrassAtPointEatable(targetGrass);
  }

  public function reproduce(): Void {
    var newCreature: Creature = new Creature(x + 50, y + 50, gameLevel);
    creatures.add(newCreature);
  }

  public function becomeScaredLeader(): Void {
    if (this.behavior.getType() != BehaviorType.COLLECTED) {
      this.behavior = new ScaredLeaderBehavior();
    }
  }

  public function becomeScaredFollower(): Void {
    if (this.behavior.getType() != BehaviorType.COLLECTED) {
      this.behavior = new ScaredFollowerBehavior();
    }
  }

  public function moveTowards(x: Float, y: Float, speed: Int = 60): Void {
    var p = FlxPoint.get(x, y);
    if (FlxMath.isDistanceToPointWithin(this, p, 3)) {
      p.put();
      return;
    }
    p.put();

    separation.x *= 10;
    separation.y *= 10;
    targetDirVector.set(x - this.x, y - this.y);
    targetDirVector.normalize();

    calculateSeparation();
    targetDirVector.add(separation.x, separation.y);

    targetDirVector.normalize();
    targetDirVector.x *= speed;
    targetDirVector.y *= speed;

    velocity.x = targetDirVector.x;
    velocity.y = targetDirVector.y;
  }

  function calculateSeparation(separationDistance: Float = 30) {
    separation.set(0, 0);
    var n = 0;
    for (c in gameLevel.creatures.members) {
      if (c != this) {
        if (FlxMath.isDistanceWithin(this, c, separationDistance)) {
          if (this.behavior.getType() == BehaviorType.HUNGRY && c.behavior.getType() == BehaviorType.HUNGRY) {
            separation.x += (c.x - x) * 3;
            separation.y += (c.y - y) * 3;
          } else {
            separation.x += c.x - x;
            separation.y += c.y - y;
          }
          n++;
        }
      }
    }
    if (n > 0) {
      separation.x /= n;
      separation.y /= n;
      separation.normalize();
      separation.negate();
    }
  }

  public function separate() {
    calculateSeparation(70);
    if (!separation.isZero()) {
      separation.x *= 100;
      separation.y *= 100;
      separation.add(x, y);
      FlxVelocity.moveTowardsPoint(this, separation, 100);
    }
  }

  public function sell(): Void {
    gameLevel.soldCreatures++;
    this.kill();
  }

  override function kill(): Void {
    super.kill();
    if (targetGrass != null && isTargetGrassEatable()) {
      gameLevel.grass.recycleTargetGrass(targetGrass);
      targetGrass = null;
    }
  }

  public function scareClosestStableCreature(): Void {
    targetCreature = CreatureUtil.findClosestStableCreature(this, creatures, 50);
    if (targetCreature != null) {
      targetCreature.becomeScaredFollower();
    }
  }
}
