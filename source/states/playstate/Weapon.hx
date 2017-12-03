package states.playstate;

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
    makeGraphic(16, 16, FlxColor.ORANGE);

    // hitSprite
    this.creatures = creatures;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }

  override public function use(directionX: Float, directionY: Float): Void {
    trace("Location: " + x + "/" + y);
    var hitSprite = new FlxSprite(x, y, "assets/bam.png");

    if (directionX != 0) {
      hitSprite.x += 48 * directionX;
      hitSprite.y += 8;
    } else if (directionY != 0) {
      hitSprite.y += 48 * directionY;
    }

    gameLevel.temporaryLayer.add(hitSprite);
    
    for (times in 1...10) {
      var sparkSprite = new FlxSprite(hitSprite.getGraphicMidpoint().x, hitSprite.getGraphicMidpoint().y, "assets/spark.png");
      sparkSprite.velocity.x = Math.random() * 400 - 200;
      sparkSprite.velocity.y = Math.random() * 400 - 200;
      gameLevel.temporaryLayer.add(sparkSprite);
    }

    if (this.creatures.members.length > 0) {
      creatures.forEach(function(creature) {
        trace("Distance from creature: " + creature.getGraphicMidpoint().distanceTo(hitSprite.getGraphicMidpoint()));
        if (creature.getGraphicMidpoint().distanceTo(hitSprite.getGraphicMidpoint()) < 30) {
          creature.hurt(1);
        }
      });
      // FlxG.overlap(hitSprite, creatures, function(self: Weapon, creature: Creature) {
      //   creature.hurt(1);
      // });
    }
  }

}