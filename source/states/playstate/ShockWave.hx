package states.playstate;

import flixel.group.FlxGroup.FlxTypedGroup;
import states.playstate.creature.CreatureUtil;
import flixel.FlxSprite;

class ShockWave {
  var parent: FlxSprite;
  var gameLevel: GameLevel;

  public function new(parent: FlxSprite, gameLevel: GameLevel) {
    this.parent = parent;
    this.gameLevel = gameLevel;
  }

  public function release(creatures: FlxTypedGroup<Creature>) {
    var point = parent.getGraphicMidpoint();
    var waveSprite = new FlxSprite(parent.x + 16, parent.y + 16, "assets/bam.png");
    gameLevel.temporaryLayer.add(waveSprite);

    var foundCreatures = CreatureUtil.findStableCreatures(parent, creatures, 100);
    foundCreatures.forEach(function(creature) {
      creature.becomeScaredLeader();
    });
  }
}