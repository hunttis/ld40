package states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import states.playstate.Creature;
import states.playstate.GameLevel;
import states.playstate.creature.BehaviorType;

class PlayState extends FlxState {

  private var currentLevel: GameLevel;
  private var currentLevelNumber: Int = 1;
  private var gameoverTimer: Float = 3;
  private var headingToGameOver: Bool = false;

	override public function create(): Void {
		super.create();
    currentLevel = loadLevel(currentLevelNumber);
    add(currentLevel);
	}

	override public function update(elapsed: Float): Void {
    super.update(elapsed);
    Util.checkQuitKey();
    checkForGameOver();
    if (headingToGameOver) {
      gameoverTimer -= elapsed;
      if (gameoverTimer < 0) {
        FlxG.switchState(new GameOverState());
      }
    }
	}

  private function loadLevel(levelNumber: Int): GameLevel {
    return new GameLevel(levelNumber);
  }

  private function checkForGameOver(): Void {
    if (!headingToGameOver && currentLevel.isGameOver()) {
      headingToGameOver = true;
      var gameoverReason: FlxText;
      if (currentLevel.salesShip.hasVisited) {
        gameoverReason = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "Let's see how you did..", 32);
      } else {
        gameoverReason = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "All your creatures are goners..", 32);
      }
      gameoverReason.x = FlxG.width / 2 - gameoverReason.width / 2;
      gameoverReason.scrollFactor.set(0,0);
      add(gameoverReason);
    }
  }

}
