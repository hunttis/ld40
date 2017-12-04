package states;

import flixel.FlxG;
import flixel.FlxState;
import audio.Music;
import states.playstate.Creature;
import states.playstate.GameLevel;
import states.playstate.creature.BehaviorType;

class PlayState extends FlxState {

  private var currentLevel: GameLevel;
  private var currentLevelNumber: Int = 1;

	override public function create(): Void {
		super.create();
    currentLevel = loadLevel(currentLevelNumber);
    add(currentLevel);
	}

	override public function update(elapsed: Float): Void {
    super.update(elapsed);
    Util.checkQuitKey();
    checkForGameOver();
    checkForLevelEnd();
    checkForMusicChange();
	}

  private function loadLevel(levelNumber: Int): GameLevel {
    return new GameLevel(levelNumber);
  }

  private function checkForGameOver(): Void {
    if (currentLevel.isGameOver()) {
      FlxG.switchState(new GameOverState());
    }
  }

  private function checkForLevelEnd(): Void {
    // Remember to account for the fact that there might not be a "next level"!
    if (currentLevel.isLevelComplete()) {
      currentLevelNumber++;
      currentLevel = loadLevel(currentLevelNumber);
    }
  }

  private function checkForMusicChange(): Void {
    // If a creature gets angry, change the music to angry_theme.
    var angryCreatureCount = currentLevel.getEnragedCreatureCount();
    if (angryCreatureCount > 0) {
      Music.playAngryTheme();
    } else {
      Music.playHappyTheme();
    }
  }
}
