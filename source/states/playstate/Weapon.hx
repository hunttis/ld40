package states.playstate;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class Weapon extends Item {

  private var creatures: FlxTypedGroup<Creature>;

  private var hitSprite: FlxSprite;

  public function new(xLoc: Float, yLoc: Float, creatures: FlxTypedGroup<Creature>, gameLevel: GameLevel) {
    super(xLoc, yLoc, gameLevel);
    loadGraphic("assets/saber.png", true, 64, 32);

    animation.add("idle", [0], 1, false);
    animation.add("swipe", [1, 2, 3, 4, 0], 10, false);
    animation.play("idle");

    // origin.set(width / 2, height);

    this.creatures = creatures;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  override public function use(facing: Int): Void {
    animation.play("swipe");

    relativeX = 0;
    relativeY = 0;
    
    if (facing == FlxObject.UP) {
      relativeAngle = 0;
      relativeY = -32; 
    } else if (facing == FlxObject.DOWN) {
      relativeAngle = 180;
      relativeY = 48;
    } else if (facing == FlxObject.LEFT) {
      relativeAngle = 270;
      relativeY = 24;
      relativeX = -32;
    } else if (facing == FlxObject.RIGHT) {
      relativeAngle = 90;
      relativeY = 24;
      relativeX = 32;
    }
    updateHitbox();

    
    trace("Location: " + facing + " " + angle);

    
    for (times in 1...10) {
      var sparkSprite = new FlxSprite(getGraphicMidpoint().x, getGraphicMidpoint().y, "assets/spark.png");
      sparkSprite.velocity.x = Math.random() * 400 - 200;
      sparkSprite.velocity.y = Math.random() * 400 - 200;
      gameLevel.temporaryLayer.add(sparkSprite);
    }

    if (this.creatures.members.length > 0) {
      // creatures.forEach(function(creature) {
      //   if (creature.getGraphicMidpoint().distanceTo(getGraphicMidpoint()) < 30) {
      //     creature.hurt(1);
      //   }
      // });
      FlxG.overlap(this, creatures, function(self: Weapon, creature: Creature) {
        creature.hurt(1);
      });
    }
  }

}