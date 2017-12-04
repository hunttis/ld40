package states.playstate;

import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;

class LevelMap extends FlxGroup {
  public var foregroundLayer(default, null): FlxTilemap;
  public var grassLayer(default, null): FlxTilemap;
  public var backgroundLayer(default, null): FlxTilemap;
  private var creatures: FlxTypedGroup<Creature>;
  private var farmer: Farmer;

  private var salesPoint: FlxPoint;

  private var tiledData: TiledMap;
  private var tileSize: Int;

  private var gameLevel: GameLevel;

  public function new(levelNumber: Int, gameLevel: GameLevel) {
    super();

    this.gameLevel = gameLevel;
    tiledData = new TiledMap("assets/level" + levelNumber + ".tmx", "assets/");

    tileSize = tiledData.tileWidth;
    var mapWidth = tiledData.width;
    var mapHeight = tiledData.height;

    creatures = new FlxTypedGroup<Creature>();
  }

  public function createTileLayers() {
    for (layer in tiledData.layers) {
      if (layer.type == TiledLayerType.TILE) {
        var tileLayer = cast(layer, TiledTileLayer);

        if (tileLayer.name == "foreground") {
          foregroundLayer = new FlxTilemap();
          foregroundLayer.loadMapFromCSV(tileLayer.csvData, "assets/tiles.png", tileSize, tileSize, null, 1, 2, 1);
        }
        else if (tileLayer.name == "grass") {
          grassLayer = new FlxTilemap();
          grassLayer.loadMapFromCSV(tileLayer.csvData, "assets/tiles.png", tileSize, tileSize, null, 1, 6, 1);
        } else if (tileLayer.name == "background") {
          backgroundLayer = new FlxTilemap();
          backgroundLayer.loadMapFromCSV(tileLayer.csvData, "assets/tiles.png", tileSize, tileSize, null, 1, 1, 1);
        }
        else {
          Sys.stderr('Tried to load a tile layer with name ${tileLayer.name} but we don\'t have a branch for it. This is a bug.');
        }
      }
    }
  }

  public function createObjectLayer() {
    for (layer in tiledData.layers) {
      if (layer.type == TiledLayerType.OBJECT) {
        var objectLayer = cast(layer, TiledObjectLayer);
        for (item in objectLayer.objects) {
          if (item.name == "creature") {
            creatures.add(new Creature(item.x, item.y, gameLevel));
          } else if (item.name == "farmer") {
            farmer = new Farmer(item.x, item.y, gameLevel);
          } else if (item.name == "salespoint") {
            salesPoint = new FlxPoint(item.x, item.y);
          } else {
            Sys.stderr('Unknown item (no branch for item.name): ${item.name}. This is a bug.');
          }
        };
      }
    }
  }

  public function getCreatures(): FlxTypedGroup<Creature> {
    return creatures;
  }

  public function getFarmer(): Farmer {
    return farmer;
  }

  public function getSalesPoint(): FlxPoint {
    return salesPoint;
  }

}
