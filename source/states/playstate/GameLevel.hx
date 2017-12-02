package states.playstate;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import states.playstate.LevelMap;
import flixel.addons.display.FlxNestedSprite;

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

	public function new(levelNumber): Void {
		super();
    loadLevel(levelNumber);
	}
	
	override public function update(elapsed: Float): Void {
    checkControls(elapsed);
    checkCollisions(elapsed);
		super.update(elapsed);
	}

  private function checkControls(elapsed: Float): Void {
  }

  private function checkCollisions(elapsed: Float): Void {
    if (levelMap != null) {
      FlxG.collide(levelMap.getForegroundLayer(), farmer);
      FlxG.collide(creatures);
      FlxG.collide(levelMap.getForegroundLayer(), creatures);
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
    
    backgroundLayer.add(levelMap.getBackgroundLayer());
    foregroundLayer.add(levelMap.getForegroundLayer());
    foregroundLayer.add(creatures);
    foregroundLayer.add(farmer);
    foregroundLayer.add(items);
    foregroundLayer.add(salesShip);

    FlxG.camera.setScrollBoundsRect(0, 0, levelMap.getForegroundLayer().width, levelMap.getForegroundLayer().height, true);
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
