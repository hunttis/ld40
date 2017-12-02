package states.playstate;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxColor;

class Weapon extends Item {

  private var creatures: FlxTypedGroup<Creature>;

  public function new(xLoc: Float, yLoc: Float, creatures: FlxTypedGroup<Creature>) {
    super(xLoc, yLoc);
    makeGraphic(16, 16, FlxColor.ORANGE);
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