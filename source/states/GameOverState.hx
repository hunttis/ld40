package states;

import audio.Music;
import flixel.util.FlxSave;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameOverState extends FlxState {
  private var gameOverText: FlxText;
  private var continueText: FlxText;
  private var scoreText: FlxText;

  private var score: Int = -1;

	override public function create(): Void {
		super.create();
    createTitle();
    createInstructions();
    createScore();
    Music.stopMusic();
	}

	override public function update(elapsed: Float): Void {
		super.update(elapsed);
    Util.checkQuitKey();
    if (FlxG.keys.justPressed.SPACE) {
      FlxG.switchState(new MainMenuState());
    }
	}

  private function createTitle(): Void {
    gameOverText = new FlxText(FlxG.width / 2, 100, "Thanks for playing!", 64);
    gameOverText.x -= gameOverText.width / 2;
    gameOverText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLUE, 2, 1);
    add(gameOverText);
  }

  private function createInstructions(): Void {
    continueText = new FlxText(FlxG.width / 2, 332, "Press space to return to main menu", 16);
    continueText.x -= continueText.width / 2;
    add(continueText);
  }

  private function createScore(): Void {
    var save = new FlxSave();
    save.bind("score");
    this.score = save.data.score;
    scoreText = new FlxText(FlxG.width / 2, 250, "You delivered " + score + " creatures!", 24);
    scoreText.x -= scoreText.width / 2;
    add(scoreText);
  }
}
