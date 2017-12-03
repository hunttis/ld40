package states;

import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.FlxSprite;

class MathUtil {
  public static function moveAwayFromObject(Source:FlxSprite, Dest:FlxSprite, Speed:Float = 60, MaxTime:Int = 0): Void {
		var a:Float = FlxAngle.angleBetween(Source, Dest);
		
		if (MaxTime > 0)
		{
			var d:Int = FlxMath.distanceBetween(Source, Dest);
			Speed = Std.int(d / (MaxTime / 1000));
		}
		
		Source.velocity.x = -(Math.cos(a) * Speed);
		Source.velocity.y = -(Math.sin(a) * Speed);
	}
}