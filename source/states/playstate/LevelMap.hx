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

    trace("Loaded map with: " + tileSize + " size tiles and " + mapWidth + "x" + mapHeight + " map");
  }

  public function createTileLayers() {
    for (layer in tiledData.layers) {
      if (layer.type == TiledLayerType.TILE) {
        var tileLayer = cast(layer, TiledTileLayer);

        trace("Loading TILE LAYER: " + layer.name);

        if (tileLayer.name == "foreground") {
          trace("Creating foreground!");
          foregroundLayer = new FlxTilemap();
          foregroundLayer.loadMapFromCSV(tileLayer.csvData, "assets/tiles.png", tileSize, tileSize, null, 1, 1, 1);
        }
        else if (tileLayer.name == "grass") {
          trace("Creating grass!");
          grassLayer = new FlxTilemap();
          grassLayer.loadMapFromCSV(tileLayer.csvData, "assets/tiles.png", tileSize, tileSize, null, 1, 6, 1);
        } else if (tileLayer.name == "background") {
          trace("Creating background!");
          backgroundLayer = new FlxTilemap();
          backgroundLayer.loadMapFromCSV(tileLayer.csvData, "assets/tiles.png", tileSize, tileSize, null, 1, 1, 1);
        }
        else {
          trace("Unknown layer, not creating! " + tileLayer.name);
        }
      }
    }
  }

  public function createObjectLayer() {
    for (layer in tiledData.layers) {
      if (layer.type == TiledLayerType.OBJECT) {
        var objectLayer = cast(layer, TiledObjectLayer);
        for (item in objectLayer.objects) {

          trace("object in layer: " + item.name);
          if (item.name == "creature") {
            creatures.add(new Creature(item.x, item.y, gameLevel));
          } else if (item.name == "farmer") {
            farmer = new Farmer(gameLevel.items, item.x, item.y);
          } else if (item.name == "salespoint") {
            salesPoint = new FlxPoint(item.x, item.y);
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