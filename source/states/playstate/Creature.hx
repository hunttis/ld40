package states.playstate;


import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxNestedSprite;

class Creature extends FlxSprite {

  private var hunger: Float;

  public function new(xLoc: Float, yLoc: Float, foods: FlxTypedGroup<Food>) {
    super(xLoc, yLoc);
    makeGraphic(16, 16, FlxColor.CYAN);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    hunger += elapsed;
    trace(hunger);

    checkForFood();

    if (hunger > 10) {
      makeGraphic(16, 16, FlxColor.RED);
    }
  }

  private function checkForFood(): Void {

  }


}
