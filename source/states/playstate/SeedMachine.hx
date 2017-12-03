package states.playstate;

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
    if (producedSeed == null || (!processing && producedSeed.pickedUp)) {
      processing = true;
      trace("Seed Machine: Processing new seed...");
    }
    if (processTime > 10) {
      processing = false;
      processTime = 0;
      var seed = new Seed(250, 250);
      producedSeed = seed;
      gameLevel.items.seeds.add(seed);
      trace("Seed Machine: Seed ready!");
    }
  }
}