package states.playstate;

import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class Weapon extends FlxGroup {

  private var creatures: FlxTypedGroup<Creature>;

  private var blade: FlxSprite;
  private var farmer: Farmer;

  private var gameLevel: GameLevel;

  public function new(gameLevel: GameLevel) {
    super();

    blade = new FlxSprite();
    blade.loadGraphic("assets/saber.png", true, 64, 64);

    blade.animation.add("idle", [0], 1, false);
    blade.animation.add("swipe", [1, 2, 3, 4, 0], 20, false);
    blade.animation.play("idle");
    add(blade);

    this.farmer = gameLevel.farmer;
    this.creatures = gameLevel.creatures;
    this.gameLevel = gameLevel;
  }

  override public function update(elapsed: Float): Void {
    if (farmer == null && gameLevel.farmer != null) {
      this.farmer = gameLevel.farmer;
    }
    setFacing(blade.facing);
    super.update(elapsed);
  }

  public function use(farmer: Farmer, facing: Int): Void {
    blade.facing = facing;
    setFacing(facing);

    blade.animation.play("swipe");

    if (this.creatures.members.length > 0) {
      FlxG.overlap(this, creatures, function(self: Weapon, creature: Creature) {
        creature.hurt(1);
      });
    }
  }

  private function setFacing(facing: Int) {
    if (facing == FlxObject.UP) {
      blade.angle = 0;
      blade.x = farmer.x;
      blade.y = farmer.y - 24;
    } else if (facing == FlxObject.DOWN) {
      blade.angle = 180;
      blade.x = farmer.x;
      blade.y = farmer.y + 24;
    } else if (facing == FlxObject.LEFT) {
      blade.angle = 270;
      blade.y = farmer.y;
      blade.x = farmer.x - 32;
    } else if (facing == FlxObject.RIGHT) {
      blade.angle = 90;
      blade.y = farmer.y;
      blade.x = farmer.x + 32;
    }
    blade.updateHitbox();
  }

}
