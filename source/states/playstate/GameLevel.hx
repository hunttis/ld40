package states.playstate;

import states.playstate.creature.BehaviorType;
import flixel.util.FlxSort;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import states.playstate.LevelMap;
import states.playstate.grass.Grass;
import flixel.addons.display.FlxNestedSprite;
import states.playstate.ship.*;
import flixel.math.FlxPoint;
import states.playstate.ui.*;
import states.playstate.decoration.*;

class GameLevel extends FlxGroup {

  public var levelMap: LevelMap;

  private var backgroundLayer: FlxGroup;
  private var foregroundLayer: FlxGroup;
  public var temporaryLayer: FlxTypedGroup<FlxSprite>;

  private var uiLayer: FlxGroup;
  public var grass(default, null): Grass;

  private var weapon: Weapon;

  public var farmer: Farmer;
  public var items: ItemGroup;
  public var salesShip: SalesShip;
  public var importShip: ImportShip;
  public var creatures: FlxTypedGroup<Creature>;
  public var seedMachine: SeedMachine;

  public var shipIndicators: ShipIndicators;

  public var soldCreatures: Int = 0;

	public function new(levelNumber): Void {
		super();
    loadLevel(levelNumber);
	}

	override public function update(elapsed: Float): Void {
    checkControls(elapsed);
    checkCollisions(elapsed);
    grass.update(elapsed);
    seedMachine.update(elapsed);
    creatures.sort(FlxSort.byY);
    temporaryLayer.forEachAlive(function(item) {
      item.hurt(0.05);
      item.alpha = item.health;
    });
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


    seedMachine = new SeedMachine(this);

    var weapon: Weapon = createWeapon(200, 200, creatures);
    items.weapons.add(weapon);

    salesShip = new SalesShip(levelMap.getSalesPoint(), this);
    importShip = new ImportShip(new FlxPoint(levelMap.foregroundLayer.width / 2, levelMap.foregroundLayer.height / 2), this);

    for (number in 1...10) {
      var backdropAsteroid = new BackdropAsteroid(Math.random() * FlxG.width, Math.random() * (FlxG.height + 256) - 128, Math.random());
      backgroundLayer.add(backdropAsteroid);
    }

    backgroundLayer.add(levelMap.backgroundLayer);
    foregroundLayer.add(levelMap.foregroundLayer);
    foregroundLayer.add(levelMap.grassLayer);
    foregroundLayer.add(creatures);
    foregroundLayer.add(farmer);
    foregroundLayer.add(items);
    foregroundLayer.add(salesShip);
    foregroundLayer.add(importShip);

    grass = new Grass(this);

    FlxG.camera.setScrollBoundsRect(0, 0, levelMap.foregroundLayer.width, levelMap.foregroundLayer.height, true);
    FlxG.camera.follow(farmer, PLATFORMER, 0.3);

    var indicatorBars = new ShipIndicators(this);
    var creatureStatistics = new CreatureStatistics(this);
    uiLayer.add(indicatorBars);
    uiLayer.add(creatureStatistics);
  }

  private function createLayers(): Void {
    backgroundLayer = new FlxGroup();
    foregroundLayer = new FlxGroup();
    temporaryLayer = new FlxTypedGroup<FlxSprite>();
    uiLayer = new FlxGroup();

    add(backgroundLayer);
    add(foregroundLayer);
    add(temporaryLayer);
    add(uiLayer);
  }

  public function isGameOver(): Bool {

    if (importShip.hasVisited) {
      for (creature in creatures.members) {
        if (creature.alive && creature.behavior.getType() != BehaviorType.ANGRY) {
          return false;
        }
      }
    }
    return importShip.hasVisited;
    #if debug // This part (cheat) of the code is only active if the -debug parameter is present
      if (FlxG.keys.justPressed.ZERO) {
        return true;
      }
    #end
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
    var food = new Food(x, y, this);
    return food;
  }

  private function createWeapon(x: Float, y: Float, creatures: FlxTypedGroup<Creature>): Weapon {
    var weapon = new Weapon(x, y, creatures, this);
    return weapon;
  }
}
