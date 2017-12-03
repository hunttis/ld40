package states.playstate.grass;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

class Grass {

  var gameLevel: GameLevel;

  var grassLayer(get, never): FlxTilemap;

  static var GRASS_GROW_DELAY_SECONDS = 0.5;
  public var grassDelay = GRASS_GROW_DELAY_SECONDS;

  var eatableGrass = new Array<FlxPoint>();

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

  function isFullyGrownGrassTile(tile: Int): Bool return tile == 11;

  function isGrowingGrassTile(tile: Int): Bool return tile >= 7 && tile <= 11;

  function isBareGroundTile(tile: Int): Bool return tile == 2;

  function isEatableTile(tile: Int): Bool return tile >= 9 && tile <= 11;

  function spreadGrassTo(x: Int, y: Int): Void {
    var tile = grassLayer.getTile(x, y);
    if (isBareGroundTile(tile) && Math.random() > 0.8) {
      grassLayer.setTile(x, y, 7);
    }
  }

  function growGrass(x: Int, y: Int, tile: Int): Void {
    var newTile = tile + 1;
    grassLayer.setTile(x, y, newTile);
    if (isEatableTile(newTile)) {
      eatableGrass.push(new FlxPoint(x, y));
    }
  }

  // Returns how fulfilling the grass was.
  public function eatGrass(x: Int, y: Int): Float {
    var tile = grassLayer.getTile(x, y);
    if (!isEatableTile(tile)) {
      return 0.0;
    }
    grassLayer.setTile(x, y, 2);
    removeEatableGrass(x, y);
    return switch (tile) {
      case 9: 0.5;
      case 10: 1.0;
      case 11: 1.5;
      case _: 0.0;
    }
  }

  function removeEatableGrass(x: Int, y: Int) {
    for (i in 0...eatableGrass.length) {
      var c = eatableGrass[i];
      if (Std.int(c.x) == x && Std.int(c.y) == y) {
        eatableGrass.splice(i, 1);
        return;
      }
    } 
  }

  public function findNearEatableGrass(x: Int, y: Int): FlxPoint {
    var minDist = FlxMath.MAX_VALUE_INT;
    var point: FlxPoint = null;
    for (c in eatableGrass) {
      var cx = Std.int(c.x);
      var cy = Std.int(c.x);
      var dist = manhattanDistance(cx, cy, x, y);
      if (dist <= 3) {
        return grassLayer.getTileCoordsByIndex(cx * cy);
      } else if (dist < minDist) {
        minDist = dist;
        point = c;
      }
    }
    return point;
  }

  public function manhattanDistance(ax: Int, ay: Int, bx: Int, by: Int): Int {
    var x = if (ax > bx) ax - bx else bx - ax;
    var y = if (ay > by) ay - by else by - ay;
    return x + y;
  }

  function get_grassLayer() return gameLevel.levelMap.grassLayer;
}