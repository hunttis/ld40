package states.playstate;


import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxNestedSprite;

class Creature extends FlxSprite {

  public function new(xLoc: Float, yLoc: Float) {
    super(xLoc, yLoc);
    makeGraphic(16, 16, FlxColor.CYAN);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
  }  
}
