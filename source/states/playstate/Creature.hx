package states.playstate;

import flixel.addons.display.FlxNestedSprite;
import states.playstate.creature.BehaviorType;
import flixel.tile.FlxTilemap;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import states.playstate.creature.Behavior;
import states.playstate.creature.IdleBehavior;
import states.playstate.creature.ScaredLeaderBehavior;
import states.playstate.creature.ScaredFollowerBehavior;

class Creature extends FlxSprite {

  public var hunger: Float = 0;
  public var satisfaction: Float = 0;
  public var scareTime: Float = 0;
  
  public var targetGrass: FlxPoint;
  public var targetCreature: Creature;
  public var tilemap: FlxTilemap;

  var foods: FlxTypedGroup<Food>;
  var creatures: FlxTypedGroup<Creature>;
  public var behavior(default, set): Behavior;
  
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

    // var shadow = new FlxNestedSprite(xLoc, yLoc, "assets/shadow.png");
    // shadow.relativeX = 0;
    // shadow.relativeY = 24;
    // add(shadow);


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
  }

  public function checkForFood(): Void {
    var pos = tileCoords();
    var grass = gameLevel.grass.findNearEatableGrass(Math.round(pos.x), Math.round(pos.y));
    targetGrass = grass;
    pos.put();
  }

  public function findClosestCreature(): Creature {
    targetCreature = findClosestCreatureWith(function(creature) return true);
    return targetCreature;
  }

  public function findClosestReproducingCreature(): Void {
    var closestCreature = findClosestCreatureWith(function(creature) return creature.behavior.getType() == BehaviorType.REPRODUCING);
    targetCreature = closestCreature;
  }

  public function findClosestStableCreature(maxDistance: Float = FlxMath.MAX_VALUE_INT): Void {
    var closestCreature = findClosestCreatureWith(maxDistance, function(creature)
      return creature.behavior.getType() != BehaviorType.ANGRY
          && creature.behavior.getType() != BehaviorType.SCARED_LEADER
          && creature.behavior.getType() != BehaviorType.SCARED_FOLLOWER);
    targetCreature = closestCreature;
  }

  public function findClosestScaredLeader(): Void {
     var closestCreature = findClosestCreatureWith(function(creature)
      return creature.behavior.getType() == BehaviorType.SCARED_LEADER);
    targetCreature = closestCreature;
  }

  public function findClosestCreatureWith(maxDistance: Float = FlxMath.MAX_VALUE_INT, predicate: Creature -> Bool): Creature {
    var closestCreature: Creature = null;
    var distance: Float = FlxMath.MAX_VALUE_INT;

    creatures.forEachAlive(function(creature) {
      if (creature != this && predicate(creature)) {
        var distanceToCreature: Float = FlxMath.distanceBetween(this, creature);
        if (distanceToCreature < distance && distanceToCreature <= maxDistance) {
          closestCreature = creature;
          distance = distanceToCreature;
        }
      }
    });
    return closestCreature;
  }

  public function eatGrass(): Void {
    var coords = tileCoords();
    var satiation = gameLevel.grass.eatGrass(Math.round(coords.x), Math.round(coords.y));
    coords.put();
    this.hunger -= satiation;
    this.targetGrass = null;
  }

  function tileCoords(): FlxPoint {
    var pos = getGraphicMidpoint();
    var index = gameLevel.levelMap.grassLayer.getTileIndexByCoords(pos);
    var width = gameLevel.levelMap.grassLayer.widthInTiles;
    var x = Math.floor(index % width);
    var y = Math.floor(index / width);
    return FlxPoint.get(x, y);
  }

  public function reproduce(): Void {
    var newCreature: Creature = new Creature(x + 50, y + 50, gameLevel);
    creatures.add(newCreature);
  }

  public function becomeScaredLeader(): Void {
    this.behavior = new ScaredLeaderBehavior();
  }

  public function becomeScaredFollower(): Void {
    this.behavior = new ScaredFollowerBehavior();
  }

  public function scareClosestStableCreature(): Void {
    findClosestStableCreature(100);
    if (targetCreature != null) {
      targetCreature.becomeScaredFollower();
    }
  }
}
