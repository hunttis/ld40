package states.playstate;

class SeedMachine {
  var processTime: Float = 0.0;
  var gameLevel: GameLevel;

  public function new(gameLevel: GameLevel) {
    this.gameLevel = gameLevel;
  }

  public function update(elapsed: Float) {
    processTime += elapsed;

    if (processTime > 5) {
      processTime = 0;
      var x = 200 + (Math.random() * 100);
      var y = 200 + (Math.random() * 100);
      gameLevel.items.seeds.add(new Seed(x, y));
    }
  }
}