package states.playstate.ui;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

class Tutorial extends FlxGroup {

  private var currentInstructions: FlxText;
  private var gameLevel: GameLevel;

  private var tutorialTimer: Float;
  private var step: TutorialStep;

  public function new(gameLevel: GameLevel) {
    super();
    this.gameLevel = gameLevel;

    var dimmer = new FlxSprite(0, FlxG.height - 20);
    dimmer.makeGraphic(FlxG.width, 20, FlxColor.BLACK);
    dimmer.alpha = 0.5;
    dimmer.scrollFactor.set(0, 0);
    add(dimmer);

    currentInstructions = new FlxText(0, FlxG.height, 0, "Hi!", 16, true);
    currentInstructions.y = FlxG.height - currentInstructions.height;
    currentInstructions.scrollFactor.set(0, 0);
    tutorialTimer = 2;
    step = WELCOME;
    add(currentInstructions);
  }

  override public function update(elapsed: Float): Void {
    tutorialTimer -= elapsed;

    if (tutorialTimer < 0) {
      tutorialTimer = 5;
      if (step == WELCOME) {
        changeStep(PICK_UP_SEEDS);
      } else if (step == SHEPHERD_TOWARDS_BEAM) {
        currentInstructions.text = "";
      }
    }

    checkChangeOfStep();

    super.update(elapsed);
  }

  private function checkChangeOfStep(): Void {
    if (step == PICK_UP_SEEDS) {
      if (gameLevel.farmer.holding != null) {
        changeStep(PLANT_SEEDS);
      }
    } else if (step == PLANT_SEEDS) {
      if (gameLevel.farmer.holding == null) {
        changeStep(PLANT_MORE);
      }
    } else if (step == PLANT_MORE) {
      if (gameLevel.farmer.holding != null) {
        changeStep(CATTLE_INCOMING);
      }
    } else if (step == CATTLE_INCOMING) {
      if (gameLevel.importShip.arrivalCounter <= 0) {
        changeStep(USE_WEAPON_WITH_C);
      }
    } else if (step == USE_WEAPON_WITH_C) {
      if (gameLevel.creatureStatistics.getEnragedCreatureCount() > 0) {
        changeStep(ENRAGED_CREATURE);
      }
    } else if (step == ENRAGED_CREATURE) {
      if (gameLevel.creatureStatistics.getEnragedCreatureCount() == 0) {
        changeStep(USE_WEAPON_WITH_C);
      }
    } else if (step == SALES_SHIP_INCOMING) {
      if (gameLevel.salesShip.arrivalCounter <= 0) {
        changeStep(SHEPHERD_TOWARDS_BEAM);
      }
    } else if (step == SHEPHERD_TOWARDS_BEAM) {
      
    }

    if ((step == ENRAGED_CREATURE || step == USE_WEAPON_WITH_C) && gameLevel.salesShip.arrivalCounter < 5) {
      changeStep(SALES_SHIP_INCOMING);
    }
  }

  private function changeStep(nextStep: TutorialStep): Void {
    if (nextStep == PICK_UP_SEEDS) {
      currentInstructions.text = "Pick up seeds with SPACEBAR.";
    } else if (nextStep == PLANT_SEEDS) {
      currentInstructions.text = "Plant seeds with somewhere SPACEBAR";
    } else if (nextStep == PLANT_MORE) {
      currentInstructions.text = "Plant some more seeds. They will be delivered periodically.";
    } else if (nextStep == CATTLE_INCOMING) {
      currentInstructions.text = "Cattle delivery will occur soon! Hope you planted some grass!";
    } else if (nextStep == USE_WEAPON_WITH_C) {
      currentInstructions.text = "If cattle gets enraged, use your weapon on them with C-key";
    } else if (nextStep == ENRAGED_CREATURE) {
      currentInstructions.text = "Creature has got enraged! Find it and put it down!";
    } else if (nextStep == SALES_SHIP_INCOMING) {
      currentInstructions.text = "Sales ship incoming!";
    } else if (nextStep == SHEPHERD_TOWARDS_BEAM) {
      currentInstructions.text = "Drive your creatures towards the beam with X";
    }
    currentInstructions.y = FlxG.height;
    FlxTween.tween(currentInstructions, {y: FlxG.height - currentInstructions.height}, 0.5);
    step = nextStep;
  }

}

enum TutorialStep {
  WELCOME;
  PICK_UP_SEEDS;
  PLANT_SEEDS;
  PLANT_MORE;
  CATTLE_INCOMING;
  USE_WEAPON_WITH_C;
  ENRAGED_CREATURE;
  SALES_SHIP_INCOMING;
  SHEPHERD_TOWARDS_BEAM;
}