package states.playstate.creature;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class CreatureUtil {

  public static function findClosestCreature(source: FlxSprite, creatures: FlxTypedGroup<Creature>): Creature {
    var targetCreature = findClosestCreatureWith(source, creatures, function(creature) return true);
    return targetCreature;
  }

  public static function findClosestReproducingCreature(source: FlxSprite,  creatures: FlxTypedGroup<Creature>): Creature {
    var closestCreature = findClosestCreatureWith(source, creatures, function(creature)
      return creature.behavior.getType() == BehaviorType.REPRODUCING);
    return closestCreature;
  }

  public static function findClosestStableCreature(source: FlxSprite,  creatures: FlxTypedGroup<Creature>, maxDistance: Float = FlxMath.MAX_VALUE_INT): Creature {
    var closestCreature = findClosestCreatureWith(source, creatures, maxDistance, function(creature)
      return creature.behavior.getType() != BehaviorType.ANGRY
          && creature.behavior.getType() != BehaviorType.SCARED_LEADER
          && creature.behavior.getType() != BehaviorType.SCARED_FOLLOWER);
    return closestCreature;
  }

  public static function findClosestScaredLeader(source: FlxSprite,  creatures: FlxTypedGroup<Creature>): Creature {
     var closestCreature = findClosestCreatureWith(source, creatures, function(creature)
      return creature.behavior.getType() == BehaviorType.SCARED_LEADER);
    return closestCreature;
  }

  public static function findClosestCreatureWith(source: FlxSprite, creatures: FlxTypedGroup<Creature>, maxDistance: Float = FlxMath.MAX_VALUE_INT, predicate: Creature -> Bool): Creature {
    var closestCreature: Creature = null;
    var distance: Float = FlxMath.MAX_VALUE_INT;

    creatures.forEachAlive(function(creature) {
      if (creature != source && predicate(creature)) {
        var distanceToCreature: Float = FlxMath.distanceBetween(source, creature);
        if (distanceToCreature < distance && distanceToCreature <= maxDistance) {
          closestCreature = creature;
          distance = distanceToCreature;
        }
      }
    });
    return closestCreature;
  }
}