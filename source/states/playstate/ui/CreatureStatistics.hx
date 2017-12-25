package states.playstate.ui;

import flixel.util.FlxColor;
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
    totalAmountOfCreatures.y = 32;
    totalAmountOfCreatures.color = FlxColor.BLACK;
    totalAmountOfCreatures.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1, 0);
    totalAmountOfCreatures.alignment = FlxTextAlign.RIGHT;

    enragedCreatures = createText("Enraged: 000", FlxG.width, 16);
    enragedCreatures.scrollFactor.set(0, 0);
    enragedCreatures.x = FlxG.width - enragedCreatures.width - 16;
    enragedCreatures.y = 32 + 16;
    enragedCreatures.color = FlxColor.BLACK;
    enragedCreatures.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1, 0);
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

    var enragedCreatureCount: Int = gameLevel.getEnragedCreatureCount();

    updateIfNewText(enragedCreatures, "Enraged: " + enragedCreatureCount);
    if (enragedCreatureCount > 0 && enragedCreatures.color != FlxColor.RED) {
      enragedCreatures.color = FlxColor.RED;
    } else if (enragedCreatureCount == 0 && enragedCreatures.color != FlxColor.BLACK) {
      enragedCreatures.color = FlxColor.BLACK;
    }
  }

  private function updateIfNewText(textObject: FlxText, newText: String) {
    if (textObject.text != newText) {
      textObject.text = newText;
    }
  }
}
