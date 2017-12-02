package states.playstate;

import flixel.math.FlxVelocity;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;

class Creature extends FlxSprite {

  private var hunger: Float = 0;
  private var targetFood: Food;
  private var foods: FlxTypedGroup<Food>;

  public function new(xLoc: Float, yLoc: Float, foods: FlxTypedGroup<Food>) {
    super(xLoc, yLoc);
    setNormalState();
    this.foods = foods;
  }

  function setNormalState() {
    loadGraphic("assets/bug.png");
  }

  function setHungryState() {
    loadGraphic("assets/bug_hungry.png");
  }

  function setAngryState() {
    loadGraphic("assets/bug_angry.png");
  }

  override public function update(elapsed: Float) {
    hunger += elapsed;
    // trace(hunger);

    velocity.x = 0;
    velocity.y = 0;

    if (hunger < 2) {
      setNormalState();
    }

    if (hunger > 2) {
      setHungryState();

      if (targetFood == null) {
        checkForFood();
      } else {
        FlxVelocity.moveTowardsObject(this, targetFood, 50);
      }
      
      if (targetFood != null) {
        FlxG.overlap(this, targetFood, function(self: Creature, food: Food) {
          food.hurt(0.1);
          hunger = 0;
        });
      }
    }

    if (hunger > 10) {
      setAngryState();
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
          distance = FlxMath.distanceBetween(this, food);
        }
      }
    });
    targetFood = closestFood;
  }


}
