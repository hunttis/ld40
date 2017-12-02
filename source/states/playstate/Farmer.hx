package states.playstate;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxNestedSprite;

class Farmer extends FlxNestedSprite {

  var item: FlxNestedSprite;
  var foods: FlxGroup;

  public function new(foods: FlxGroup, xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc);

    this.foods = foods;

    makeGraphic(16, 16, FlxColor.RED);
    maxVelocity.set(1, 1);
  }

  override public function update(elapsed: Float): Void {
    checkKeys(elapsed);

    // You probably want to do most of the logic before super.update(). This is because after the update, 
    // colliding objects are separated and will no longer be touching.

    super.update(elapsed);
  }

  private function checkKeys(elapsed: Float): Void {
    #if (!mobile) // Keys are not available on mobile

      if (FlxG.keys.pressed.UP) {
        y -= maxVelocity.y;
      }

      if (FlxG.keys.pressed.DOWN) {
        y += maxVelocity.y;
      }

      if (FlxG.keys.pressed.LEFT) {
        x -= maxVelocity.x;
      }

      if (FlxG.keys.pressed.RIGHT) {
        x += maxVelocity.x;
      }

      if (FlxG.keys.justPressed.SPACE) {
        if (item == null) {
          pickup();
        } else {
          drop();
        }
      }
    #end
  }

  private function pickup(): Void {
    item = createFood();
    add(item);
  }

  private function drop(): Void {
    remove(item);
    foods.add(item);
    item = null;
  }

  private function createFood(): FlxNestedSprite {
    var food = new FlxNestedSprite(0, 0);
    food.makeGraphic(16, 16, FlxColor.GREEN);
    food.relativeX = 10;
    food.relativeY = 10;   
    return food;
  }
}