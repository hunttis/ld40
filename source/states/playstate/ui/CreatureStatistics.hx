package states.playstate.ui;

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

    totalAmountOfCreatures = createText("Creature total", gameLevel.creatures, 32);
    totalAmountOfCreatures.scrollFactor.set(0, 0);

    enragedCreatures = createText("Enraged", gameLevel.creatures, 48);
    enragedCreatures.scrollFactor.set(0, 0);

    add(totalAmountOfCreatures);
    add(enragedCreatures);
  }

  private function createText(name: String, creatures: FlxTypedGroup<Creature>, yLoc): FlxText {
    return new FlxText(0, yLoc, 0, '${name}: ${creatures.members.length}', 12, true);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);

    updateIfNewText(totalAmountOfCreatures, "Creature total: " + gameLevel.creatures.countLiving);
    updateIfNewText(enragedCreatures, "Enraged: " + getEnragedCreatureCount());
  }

  private function updateIfNewText(textObject: FlxText, newText: String) {
    if (textObject.text != newText) {
      trace("Updating text: " + newText);
      textObject.text = newText;
    }
  }

  private function getEnragedCreatureCount(): Int {
    var angryCount: Int = 0;
    for (creature in gameLevel.creatures.members) {
      if (creature.alive && creature.behavior.getType() == BehaviorType.ANGRY) {
        angryCount ++;
      }
    }
    return angryCount;
  }
}
