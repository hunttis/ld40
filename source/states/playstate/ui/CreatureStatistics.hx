package states.playstate.ui;

import flixel.text.FlxText;
import flixel.group.FlxGroup;

class CreatureStatistics extends FlxGroup {
  var totalAmountOfCreaturesText: FlxText;

  public function new(gameLevel: GameLevel) {
    super();
    totalAmountOfCreaturesText = createText("Total amount of creatures", gameLevel.creatures);
    totalAmountOfCreaturesText.scrollFactor.set(0, 0);
    add(totalAmountOfCreaturesText);
  }

  private function createText(name: String, creatures: FlxTypedGroup<Creature>): FlxText {
    return new FlxText(0, 32, 50, 'Sook kook: ${creatures.members.length}', 12, true);
  }
}
