package states.playstate;

import flixel.math.FlxVelocity;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;

class Creature extends FlxSprite {

  private var hunger: Float = 0;
  
  private var targetFood: Food;
  private var targetCreature: Creature;

  private var foods: FlxTypedGroup<Food>;
  private var creatures: FlxTypedGroup<Creature>;
  private var state: CreatureState;

  public function new(xLoc: Float, yLoc: Float, foods: FlxTypedGroup<Food>, creatures: FlxTypedGroup<Creature>) {
    super(xLoc, yLoc);
    setNormalState();
    this.foods = foods;
    this.creatures = creatures;
    hunger = Math.random() * 10;
  }

  function setNormalState() {
    state = IDLE;
    loadGraphic("assets/bug.png");
  }

  function setHungryState() {
    state = HUNGRY;
    loadGraphic("assets/bug_hungry.png");
  }

  function setAngryState() {
    state = ANGRY;
    loadGraphic("assets/bug_angry.png");
  }

  function setScaredState() {
    state = SCARED;
  }

  override public function update(elapsed: Float) {
    hunger += elapsed;
    // trace(hunger);

    velocity.x = 0;
    velocity.y = 0;

    if (state != IDLE && hunger < 2) {
      setNormalState();
    }

    if (state != HUNGRY && hunger > 2) {
      setHungryState();
    }

    if (state != ANGRY && hunger > 10) {
      setAngryState();
    }

    if (state == HUNGRY) {
      if (targetFood == null) {
        checkForFood();
      } else {
        FlxVelocity.moveTowardsObject(this, targetFood, 50);
        FlxG.overlap(this, targetFood, function(self: Creature, food: Food) {
          food.hurt(0.1);
          hunger = 0;
        });
        
      }
    }

    if (state == ANGRY) {
      if (targetCreature == null) {
        findClosestCreature();
      } else {
        FlxVelocity.moveTowardsObject(this, targetCreature, 30);
        FlxG.overlap(this, targetCreature, function(self: Creature, creature: Creature) {
          creature.hurt(0.1);
          if (!creature.alive) {
            targetCreature = null;
          }
        });
      }
    }

    super.update(elapsed);

  }

  private function checkForFood(): Void {
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

  private function findClosestCreature(): Void {
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

enum CreatureState {
  IDLE;
  HUNGRY;
  ANGRY;
  SCARED;
}
