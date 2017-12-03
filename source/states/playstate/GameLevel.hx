package states.playstate;

import flixel.FlxG;
import flixel.group.FlxGroup;
import states.playstate.LevelMap;

class GameLevel extends FlxGroup {

  public var levelMap: LevelMap;

  private var backgroundLayer: FlxGroup;
  private var foregroundLayer: FlxGroup;
  private var uiLayer: FlxGroup;

  private var farmer: Farmer;
  private var weapon: Weapon;

  public var items: ItemGroup;
  public var salesShip: SalesShip;
  public var creatures: FlxTypedGroup<Creature>;

  static var GRASS_GROW_DELAY_SECONDS = 0.5;
  public var grassDelay = GRASS_GROW_DELAY_SECONDS;

	public function new(levelNumber): Void {
		super();
    loadLevel(levelNumber);
	}
	
	override public function update(elapsed: Float): Void {
    checkControls(elapsed);
    checkCollisions(elapsed);
    updateGrass(elapsed);
		super.update(elapsed);
	}

  private function checkControls(elapsed: Float): Void {
  }

  private function checkCollisions(elapsed: Float): Void {
    if (levelMap != null) {
      FlxG.collide(levelMap.foregroundLayer, farmer);
      FlxG.collide(creatures);
      FlxG.collide(levelMap.foregroundLayer, creatures);
    }
  }

  private function loadLevel(levelNumber: Int): Void {
    createLayers();

    items = new ItemGroup();

    levelMap = new LevelMap(levelNumber, this);
    creatures = levelMap.getCreatures();
    levelMap.createTileLayers();
    levelMap.createObjectLayer();
    add(levelMap);

    farmer = levelMap.getFarmer();

    var food: Food = createFood(100, 100);
    items.foods.add(food);
    
    var weapon: Weapon = createWeapon(200, 200, creatures);
    items.weapons.add(weapon);

    salesShip = new SalesShip(levelMap.getSalesPoint(), creatures);
    
    backgroundLayer.add(levelMap.backgroundLayer);
    foregroundLayer.add(levelMap.foregroundLayer);
    foregroundLayer.add(levelMap.grassLayer);
    foregroundLayer.add(creatures);
    foregroundLayer.add(farmer);
    foregroundLayer.add(items);
    foregroundLayer.add(salesShip);

    FlxG.camera.setScrollBoundsRect(0, 0, levelMap.foregroundLayer.width, levelMap.foregroundLayer.height, true);
    FlxG.camera.follow(farmer, PLATFORMER, 0.3);
  }

  private function createLayers(): Void {
    backgroundLayer = new FlxGroup();
    foregroundLayer = new FlxGroup();
    uiLayer = new FlxGroup();

    add(backgroundLayer);
    add(foregroundLayer);
    add(uiLayer);
  }

  function updateGrass(elapsed: Float) {
    grassDelay -= elapsed;
    if (grassDelay > 0) {
      return;
    }
    trace("grass is growing");
    grassDelay = GRASS_GROW_DELAY_SECONDS;

    var width = levelMap.grassLayer.widthInTiles;
    var height = levelMap.grassLayer.heightInTiles;

    for (y in 0...height) {
      for (x in 0...width) {
        var tile = levelMap.grassLayer.getTile(x, y);
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
    var tile = levelMap.grassLayer.getTile(x, y);
    if (isBareGroundTile(tile) && Math.random() > 0.8) {
      levelMap.grassLayer.setTile(x, y, 7);
    }
  }

  function growGrass(x: Int, y: Int, tile: Int): Void {
    levelMap.grassLayer.setTile(x, y, tile + 1);
  }

  public function isGameOver(): Bool {
    #if debug // This part (cheat) of the code is only active if the -debug parameter is present
      if (FlxG.keys.justPressed.ZERO) {
        return true;
      }
    #end
    // Write your game over check here
    return false;
  }

  public function isLevelComplete(): Bool {
    #if debug // Read above comment
      if (FlxG.keys.justPressed.NINE) {
        return true;
      }
    #end
    // Write your level completion terms here
    return false;
  }

  private function createFood(x: Float, y: Float): Food {
    var food = new Food(x, y);
    return food;
  }

  private function createWeapon(x: Float, y: Float, creatures: FlxTypedGroup<Creature>): Weapon {
    var weapon = new Weapon(x, y, creatures);
    return weapon;
  }
}
