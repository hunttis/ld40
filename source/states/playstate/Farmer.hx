package states.playstate;

import states.playstate.creature.BehaviorType;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.display.FlxNestedSprite;

class Farmer extends FlxNestedSprite {

  var holding: Item;
  var gameLevel: GameLevel;
  var items: ItemGroup;
  var creatures: FlxTypedGroup<Creature>;
  var weapon: Weapon;

  var throwingDistance: Float;

  public function new(xLoc: Float, yLoc: Float, gameLevel: GameLevel) {
    super(xLoc, yLoc);

    this.gameLevel = gameLevel;
    this.items = gameLevel.items;
    this.creatures = gameLevel.creatures;

    loadGraphic("assets/farmer.png");
    maxVelocity.set(300, 300);
    throwingDistance = 150;
    centerOrigin();
  }

  override public function update(elapsed: Float): Void {
    checkKeys(elapsed);

    // You probably want to do most of the logic before super.update(). This is because after the update, 
    // colliding objects are separated and will no longer be touching.

    super.update(elapsed);
  }

  private function checkKeys(elapsed: Float): Void {
    #if (!mobile) // Keys are not available on mobile

      velocity.y = 0;
      velocity.x = 0;

      if (FlxG.keys.pressed.UP) {
        velocity.y = -maxVelocity.y;
        facing = FlxObject.UP;
      }

      if (FlxG.keys.pressed.DOWN) {
        velocity.y = maxVelocity.y;
        facing = FlxObject.DOWN;
      }

      if (FlxG.keys.pressed.LEFT) {
        velocity.x = -maxVelocity.x;
        facing = FlxObject.LEFT;
      }

      if (FlxG.keys.pressed.RIGHT) {
        velocity.x = maxVelocity.x;
        facing = FlxObject.RIGHT;
      }

      if (FlxG.keys.justPressed.SPACE) {
        if (holding == null) {
          pickup();
        } else {
          drop();
        }
      }

      if (FlxG.keys.justPressed.C) {
        if (holding != null) {
          attack();
        }
      }

      if (FlxG.keys.justPressed.V) {
        if (holding != null) {
          throwItem();
        }
      }

      if (FlxG.keys.justPressed.S) {
        scareClosestCreature();
      }
    #end
  }

  private function pickup(): Void {
    FlxG.overlap(this, items, function(self: Farmer, item: Item) {
      if (this.holding == null) {
        this.add(item);
        item.relativeX = 10;
        item.relativeY = 10;
        this.holding = item;
      }
    });
  }

  private function drop(): Void {
    holding.velocity.x = 0;
    holding.velocity.y = 0;
    remove(holding);
    items.add(holding);
    holding = null;
  }

  private function attack(): Void {
    this.holding.use();
  }

  private function throwItem(): Void {
    switch this.facing {
      case FlxObject.UP: FlxTween.tween(holding, {y: holding.y - throwingDistance}, 0.5, {ease: FlxEase.quadIn});
      case FlxObject.DOWN: FlxTween.tween(holding, {y: holding.y + throwingDistance}, 0.5, {ease: FlxEase.quadIn});
      case FlxObject.LEFT: FlxTween.tween(holding, {x: holding.x - throwingDistance}, 0.5, {ease: FlxEase.quadIn});
      case FlxObject.RIGHT: FlxTween.tween(holding, {x: holding.x + throwingDistance}, 0.5, {ease: FlxEase.quadIn});
    }
    drop();
  }

  private function scareClosestCreature(): Void {
    var creature = findClosestStableCreature(200);
    if (creature != null) {
      creature.becomeScaredLeader();
    }
  }

  private function findClosestStableCreature(maxDistance: Float = FlxMath.MAX_VALUE_INT): Creature {
    var closestCreature = findClosestCreatureWith(maxDistance, function(creature)
      return creature.behavior.getType() != BehaviorType.ANGRY
          && creature.behavior.getType() != BehaviorType.SCARED_LEADER 
          && creature.behavior.getType() != BehaviorType.SCARED_FOLLOWER);
    return closestCreature;
  }

  private function findClosestCreatureWith(maxDistance: Float = FlxMath.MAX_VALUE_INT, predicate: Creature -> Bool): Creature {
    var closestCreature: Creature = null;
    var distance: Float = FlxMath.MAX_VALUE_INT;

    creatures.forEachAlive(function(creature) {
      if (predicate(creature)) {
        var distanceToCreature: Float = FlxMath.distanceBetween(this, creature);
        if (distanceToCreature < distance && distanceToCreature <= maxDistance) {
          closestCreature = creature;
          distance = distanceToCreature;
        }
      }
    });
    return closestCreature;
  }
}
