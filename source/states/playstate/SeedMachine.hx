package states.playstate;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
class SeedMachine {
  var processing: Bool = false;
  var processTime: Float = 5.0;
  var gameLevel: GameLevel;
  var producedSeed: Seed;

  public function new(gameLevel: GameLevel) {
    this.gameLevel = gameLevel;
  }

  public function update(elapsed: Float) {
    if (processing) {
      processTime += elapsed;
    }
    if ((producedSeed == null && !processing) || (!processing && producedSeed.pickedUp)) {
      processing = true;
    }
    if (processTime > 5) {
      processing = false;
      processTime = 0;
      var seed = new Seed(250, 0, gameLevel);
      FlxTween.tween(seed, {x: 250, y: 250}, 1, { ease: FlxEase.quadOut, onComplete: seed.landOnAsteroid} );
      producedSeed = seed;
      gameLevel.items.seeds.add(seed);
      trace("Seed ready!");
    }
  }
}
