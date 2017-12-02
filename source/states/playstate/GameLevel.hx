package states.playstate;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import states.playstate.LevelMap;
import flixel.addons.display.FlxNestedSprite;

class GameLevel extends FlxGroup {

  private var levelMap: LevelMap;

  private var backgroundLayer: FlxGroup;
  private var foregroundLayer: FlxGroup;
  private var uiLayer: FlxGroup;

  private var farmer: Farmer;
  private var tileCursor: TileCursor;
  private var foods: FlxTypedGroup<FlxNestedSprite>;

	public function new(levelNumber): Void {
		super();
    loadLevel(levelNumber);
    createTileCursor();
	}
	
	override public function update(elapsed: Float): Void {
		super.update(elapsed);
    checkControls(elapsed);
	}

  private function checkControls(elapsed: Float): Void {
    checkMouse(elapsed);
    checkCollisions(elapsed);
  }

  private function checkCollisions(elapsed: Float): Void {
    if (levelMap != null) {
      FlxG.collide(levelMap.getForegroundLayer(), farmer);
    }
  }

  private function checkMouse(elapsed: Float): Void {
    #if (!mobile)
      // Mouse not on mobile!
      
    #end
  }

  private function loadLevel(levelNumber: Int): Void {
    createLayers();

    levelMap = new LevelMap(levelNumber);
    add(levelMap);

    backgroundLayer.add(levelMap.getBackgroundLayer());

    foregroundLayer.add(levelMap.getForegroundLayer());

    foods = new FlxTypedGroup();
    var food = createFood(100, 100);
    foods.add(food);
    foregroundLayer.add(foods);

    farmer = new Farmer(foods, 100, 100);
    foregroundLayer.add(farmer);

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

  private function createTileCursor(): Void {
    #if (!mobile)
      // Mouse not on mobile!
      tileCursor = new TileCursor();
      uiLayer.add(tileCursor);
    #end
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

  private function createFood(x: Float, y: Float): FlxNestedSprite {
    var food = new FlxNestedSprite(x, y);
    food.makeGraphic(16, 16, FlxColor.GREEN);
    return food;
  }
}
