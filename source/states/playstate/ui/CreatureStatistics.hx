package states.playstate.ui;

import flixel.FlxG;
import states.playstate.creature.BehaviorType;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class CreatureStatistics extends FlxGroup {
  var gameLevel: GameLevel;

  var totalAmountOfCreatures: FlxText;
  var enragedCreatures: FlxText;

  public function new(gameLevel: GameLevel) {
    super();

    this.gameLevel = gameLevel;

    totalAmountOfCreatures = createText("Creature total: 000", FlxG.width, 0);
    totalAmountOfCreatures.scrollFactor.set(0, 0);
    totalAmountOfCreatures.x = FlxG.width - totalAmountOfCreatures.width - 16;
    totalAmountOfCreatures.alignment = FlxTextAlign.RIGHT;

    enragedCreatures = createText("Enraged: 000", FlxG.width, 16);
    enragedCreatures.scrollFactor.set(0, 0);
    enragedCreatures.x = FlxG.width - enragedCreatures.width - 16;
    enragedCreatures.alignment = FlxTextAlign.RIGHT;

    add(totalAmountOfCreatures);
    add(enragedCreatures);
  }

  private function createText(name: String, xLoc: Int, yLoc: Int): FlxText {
    return new FlxText(xLoc, yLoc, 0, name, 12, true);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);

    updateIfNewText(totalAmountOfCreatures, "Creature total: " + gameLevel.getLivingCreatureCount());
    updateIfNewText(enragedCreatures, "Enraged: " + gameLevel.getEnragedCreatureCount());
  }

  private function updateIfNewText(textObject: FlxText, newText: String) {
    if (textObject.text != newText) {
      textObject.text = newText;
    }
  }
}
