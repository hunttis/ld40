package states.playstate;

import flixel.util.FlxSave;
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
import audio.Music;

class GameLevel extends FlxGroup {

  public var levelMap: LevelMap;

  private var backgroundLayer: FlxGroup;
  public var foregroundLayer: FlxGroup;
  public var temporaryLayer: FlxTypedGroup<FlxSprite>;

  private var uiLayer: FlxGroup;
  public var grass(default, null): Grass;

  public var farmer: Farmer;
  public var items: ItemGroup;
  public var salesShip: SalesShip;
  public var importShip: ImportShip;
  public var creatures: FlxTypedGroup<Creature>;
  public var seedMachine: SeedMachine;
  public var schockWaves: FlxTypedGroup<ShockWave> = new FlxTypedGroup();

  public var shipIndicators: ShipIndicators;
  public var creatureStatistics: CreatureStatistics;
  public var tutorial: Tutorial;

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
    checkForMusicChange();
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
    foregroundLayer.add(schockWaves);
    foregroundLayer.add(items);
    foregroundLayer.add(salesShip);
    foregroundLayer.add(importShip);

    grass = new Grass(this);

    FlxG.camera.setScrollBoundsRect(0, 0, levelMap.foregroundLayer.width, levelMap.foregroundLayer.height, true);
    FlxG.camera.follow(farmer, PLATFORMER, 0.3);

    var indicatorBars = new ShipIndicators(this);
    creatureStatistics = new CreatureStatistics(this);
    tutorial = new Tutorial(this);

    uiLayer.add(indicatorBars);
    uiLayer.add(creatureStatistics);
    uiLayer.add(tutorial);
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
      var save = new FlxSave();
      save.bind("score");
      save.erase();
      save.bind("score");
      save.data.score = soldCreatures;
      save.flush();
      return true;
    }
    return importShip.hasVisited && salesShip.hasVisited;
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

  public function getLivingCreatureCount(): Int {
    var livingCreatureCount = creatures.countLiving();
    if (livingCreatureCount == -1) {
      return 0;
    }

    return livingCreatureCount;
  }

  public function getEnragedCreatureCount(): Int {
    var angryCount: Int = 0;
    for (creature in creatures.members) {
      if (creature.alive && creature.behavior.getType() == BehaviorType.ANGRY) {
        angryCount ++;
      }
    }
    return angryCount;
  }

  private function createFood(x: Float, y: Float): Food {
    var food = new Food(x, y, this);
    return food;
  }

  private function checkForMusicChange(): Void {
    if (creatures.members.length > 0 && creatureStatistics.getEnragedCreatureCount() > Math.round(creatures.members.length / 5)) {
      Music.playAngryTheme();
    } else {
      Music.playHappyTheme();
    }
  }
}
