package states.playstate;

import states.playstate.creature.BehaviorType;
import flixel.tile.FlxTilemap;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import states.playstate.creature.Behavior;
import states.playstate.creature.IdleBehavior;
import states.playstate.creature.ScaredLeaderBehavior;

class Creature extends FlxSprite {

  public var hunger: Float = 0;
  public var satisfaction: Float = 0;
  public var scareTime: Float = 0;
  
  public var targetFood: Food;
  public var targetCreature: Creature;
  public var tilemap: FlxTilemap;

  var foods: FlxTypedGroup<Food>;
  var creatures: FlxTypedGroup<Creature>;
  public var behavior(default, set): Behavior;
  
  public var gameLevel: GameLevel;

  public function new(xLoc: Float, yLoc: Float, gameLevel: GameLevel) {
    super(xLoc, yLoc);

    this.gameLevel = gameLevel;
    this.tilemap = gameLevel.levelMap.foregroundLayer;

    behavior = new IdleBehavior();
    this.foods = gameLevel.items.foods;
    this.creatures = gameLevel.creatures;
    // hunger = Math.random() * 10;
  }

  public function set_behavior(nextBehavior: Behavior) {
    nextBehavior.init(this);
    return behavior = nextBehavior;
  }

  override public function update(elapsed: Float) {
    // trace(hunger);

    velocity.x = 0;
    velocity.y = 0;

    behavior.update(this, elapsed);

    super.update(elapsed);
  }

  public function checkForFood(): Void {
    var closestFood: Food = null;
    var distance: Float = 1000000;
    foods.forEachAlive(function(food) {
      var distanceToFood: Float = FlxMath.distanceBetween(this, food);
      if (distanceToFood < 100) {
        if (closestFood == null || distanceToFood < distance) {
          trace("Found closest food!");
          closestFood = food;
          distance = distanceToFood;
        }
      }
    });
    targetFood = closestFood;
  }

  public function findClosestCreature(): Creature {
    targetCreature = findClosestCreatureWith(function(creature) return true);
    return targetCreature;
  }

  public function findClosestReproducingCreature(): Void {
    var closestCreature = findClosestCreatureWith(function(creature) return creature.behavior.getType() == BehaviorType.REPRODUCING);
    targetCreature = closestCreature;
  }

  public function findClosestCreatureWith(predicate: Creature -> Bool): Creature {
    var closestCreature: Creature = null;
    var distance: Float = FlxMath.MAX_VALUE_INT;

    creatures.forEachAlive(function(creature) {
      if (creature != this && predicate(creature)) {
        var distanceToCreature: Float = FlxMath.distanceBetween(this, creature);
        if (distanceToCreature < distance) {
          closestCreature = creature;
          distance = distanceToCreature;
        }
      }
    });
    return closestCreature;
  }

  public function reproduce(): Void {
    var newCreature: Creature = new Creature(x + 50, y + 50, gameLevel);
    creatures.add(newCreature);
  }

  public function becomeScaredLeader(): Void {
    if (this.behavior.getType() != BehaviorType.ANGRY) {
      this.behavior = new ScaredLeaderBehavior();
    }
  }
}
