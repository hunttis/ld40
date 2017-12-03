package states.playstate.grass;

import flixel.tile.FlxTilemap;

class Grass {

  var gameLevel: GameLevel;

  var grassLayer(get, never): FlxTilemap;

  static var GRASS_GROW_DELAY_SECONDS = 0.5;
  public var grassDelay = GRASS_GROW_DELAY_SECONDS;

  public function new(gameLevel: GameLevel) {
    this.gameLevel = gameLevel;
  }

  public function update(elapsed: Float) {
    grassDelay -= elapsed;
    if (grassDelay > 0) {
      return;
    }
    grassDelay = GRASS_GROW_DELAY_SECONDS;

    var width = grassLayer.widthInTiles;
    var height = grassLayer.heightInTiles;

    for (y in 0...height) {
      for (x in 0...width) {
        var tile = grassLayer.getTile(x, y);
        if (isFullyGrownGrassTile(tile)) {
          // UP
          if (y > 0) {
            spreadGrassTo(x, y-1);
          }
          // DOWN
          if (y < height - 1) {
            spreadGrassTo(x, y+1);
          }
          // LEFT
          if (x > 0) {
            spreadGrassTo(x-1, y);
          }
          // RIGHT
          if (x < width - 1) {
            spreadGrassTo(x+1, y);
          }
        } else if (isGrowingGrassTile(tile)) {
          growGrass(x, y, tile);
        }
      }
    }
  }

  function isFullyGrownGrassTile(tile: Int): Bool {
    return tile == 11;
  }

  function isGrowingGrassTile(tile: Int): Bool {
    return tile >= 7 && tile <= 11;
  }

  function isBareGroundTile(tile: Int): Bool {
    return tile == 2;
  }

  function spreadGrassTo(x: Int, y: Int): Void {
    var tile = grassLayer.getTile(x, y);
    if (isBareGroundTile(tile) && Math.random() > 0.8) {
      grassLayer.setTile(x, y, 7);
    }
  }

  function growGrass(x: Int, y: Int, tile: Int): Void {
    grassLayer.setTile(x, y, tile + 1);
  }

  function get_grassLayer() return gameLevel.levelMap.grassLayer;
}