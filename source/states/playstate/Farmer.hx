package states.playstate;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxNestedSprite;

class Farmer extends FlxNestedSprite {

  var holding: Item;
  var items: ItemGroup;
  var weapon: Weapon;

  public function new(items: ItemGroup, xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc);

    this.items = items;

    makeGraphic(16, 16, FlxColor.RED);
    maxVelocity.set(3, 3);
    centerOrigin();
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
        if (holding == null) {
          pickup();
        } else {
          drop();
        }
      }

      if (FlxG.keys.justPressed.C) {
        if (holding != null) {
          attack();
        }
      }
    #end
  }

  private function pickup(): Void {
    FlxG.overlap(this, items, function(self: Farmer, item: Item) {
      if (this.holding == null) {
        this.add(item);
        item.relativeX = 10;
        item.relativeY = 10;
        this.holding = item;
      }
    });
  }

  private function drop(): Void {
    remove(holding);
    items.add(holding);
    holding = null;
  }

  private function attack(): Void {
    this.holding.use();
  }
}
