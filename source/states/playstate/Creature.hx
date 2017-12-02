package states.playstate;

import flixel.tile.FlxTilemap;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import states.playstate.creature.Behavior;
import states.playstate.creature.IdleBehavior;

class Creature extends FlxSprite {

  public var hunger: Float = 0;
  public var satisfaction: Float = 0;
  
  public var targetFood: Food;
  public var targetCreature: Creature;
  public var tilemap: FlxTilemap;

  var foods: FlxTypedGroup<Food>;
  var creatures: FlxTypedGroup<Creature>;
  public var behavior(default, set): Behavior;

  public function new(xLoc: Float, yLoc: Float, tilemap: FlxTilemap, foods: FlxTypedGroup<Food>, creatures: FlxTypedGroup<Creature>) {
    super(xLoc, yLoc);
    this.tilemap = tilemap;
    behavior = new IdleBehavior();
    this.foods = foods;
    this.creatures = creatures;
    hunger = Math.random() * 10;
  }

  public function set_behavior(nextBehavior: Behavior) {
    nextBehavior.init(this);
    return behavior = nextBehavior;
  }

  override public function update(elapsed: Float) {
    hunger += elapsed;
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
    var closestCreature: Creature = null;
    var distance: Float = 100000;

    creatures.forEachAlive(function(creature) {
      var distanceToCreature: Float = FlxMath.distanceBetween(this, creature);
      if (this != creature && (closestCreature == null || distanceToCreature < distance)) {
        closestCreature = creature;
        distance = distanceToCreature;
      }
    });
    targetCreature = closestCreature;
    return closestCreature;
  }

  public function findClosestReproducingCreature(): Void {
    var closestCreature: Creature = null;
    var distance: Float = 100000;

    creatures.forEachAlive(function(creature) {
      var distanceToCreature: Float = FlxMath.distanceBetween(this, creature);
      if (this != creature && (closestCreature == null || distanceToCreature < distance)) {
        closestCreature = creature;
        distance = distanceToCreature;
      }
    });
    targetCreature = closestCreature;
  }
}
