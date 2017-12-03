package states.playstate.ui;

import flixel.text.FlxText;
import flixel.group.FlxGroup;

class CreatureStatistics extends FlxGroup {
  var totalAmountOfCreaturesText:FlxText;

  public function new(gameLevel:GameLevel) {
    super();
    totalAmountOfCreaturesText = createText("Total amount of creatures");
    add(totalAmountOfCreaturesText);
  }

  private function createText(name:String): FlxText {
    return new FlxText(0, 32, 50, "Sook kook", 12, true);
  }
}