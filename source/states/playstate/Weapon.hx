package states.playstate;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Weapon extends Item {

  private var creatures: FlxTypedGroup<Creature>;

  private var hitSprite: FlxSprite;

  public function new(xLoc: Float, yLoc: Float, creatures: FlxTypedGroup<Creature>, gameLevel: GameLevel) {
    super(xLoc, yLoc, gameLevel);
    makeGraphic(16, 16, FlxColor.ORANGE);

    // hitSprite
    this.creatures = creatures;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  override public function use(): Void {
    if (this.creatures.members.length > 0) {
      FlxG.overlap(this, creatures, function(self: Weapon, creature: Creature) {
        creature.hurt(1);
      });
    }
  }

}