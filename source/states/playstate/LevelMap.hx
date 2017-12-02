package states.playstate;

import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;

class LevelMap extends FlxGroup {

  private var foregroundLayer: FlxTilemap;
  private var backgroundLayer: FlxTilemap;
  private var creatures: FlxTypedGroup<Creature>;
  private var farmer: Farmer;

  private var salesPoint: FlxPoint;

  public function new(levelNumber: Int, items: ItemGroup) {
    super();
    var tiledData: TiledMap = new TiledMap("assets/level" + levelNumber + ".tmx", "assets/");

    var tileSize = tiledData.tileWidth;
    var mapWidth = tiledData.width;
    var mapHeight = tiledData.height;

    creatures = new FlxTypedGroup<Creature>();

    trace("Loaded map with: " + tileSize + " size tiles and " + mapWidth + "x" + mapHeight + " map");

    for (layer in tiledData.layers) {
      if (layer.type == TiledLayerType.TILE) {
        var tileLayer = cast(layer, TiledTileLayer);

        trace("Loading TILE LAYER: " + layer.name);

        if (tileLayer.name == "foreground") {
          trace("Creating foreground!");
          foregroundLayer = new FlxTilemap();
          foregroundLayer.loadMapFromCSV(tileLayer.csvData, "assets/foregroundtiles.png", tileSize, tileSize, null, 1, 1, 1);
        }
        else if (tileLayer.name == "background") {
          trace("Creating background!");
          backgroundLayer = new FlxTilemap();
          backgroundLayer.loadMapFromCSV(tileLayer.csvData, "assets/backgroundtiles.png", tileSize, tileSize, null, 65, 65, 65);
        }
        else {
          trace("Unknown layer, not creating! " + tileLayer.name);
        }
      } else if (layer.type == TiledLayerType.OBJECT) {
        var objectLayer = cast(layer, TiledObjectLayer);
        for (item in objectLayer.objects) {

          trace("object in layer: " + item.name);
          if (item.name == "creature") {
            creatures.add(new Creature(item.x, item.y, foregroundLayer, items.foods, creatures));
          } else if (item.name == "farmer") {
            farmer = new Farmer(items, item.x, item.y);
          } else if (item.name == "salespoint") {
            salesPoint = new FlxPoint(item.x, item.y);
          }

        };
      } else {
        trace("Other layer!");
      }
    }
  }

  public function getForegroundLayer(): FlxTilemap {
    return foregroundLayer;
  }

  public function getBackgroundLayer(): FlxTilemap {
    return backgroundLayer;
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