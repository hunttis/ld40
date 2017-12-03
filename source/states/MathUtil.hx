package states;

import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.FlxSprite;

class MathUtil {

  public static function moveAwayFromObject(source:FlxSprite, dest:FlxSprite, speed:Float = 60, maxTime:Int = 0): Void {
		var a: Float = FlxAngle.angleBetween(source, dest);
		
		if (maxTime > 0) {
			var d: Int = FlxMath.distanceBetween(source, dest);
			speed = Std.int(d / (maxTime / 1000));
		}
		
		source.velocity.x = -(Math.cos(a) * speed);
		source.velocity.y = -(Math.sin(a) * speed);
	}
}