package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenuState extends FlxState {

  private var titleText: FlxText;
  private var startText: FlxText;
  private var keyHelp: FlxText;

	override public function create(): Void {
		super.create();
    createTitle();
    createInstructions();
    createKeyHelp();
	}

	override public function update(elapsed: Float): Void {
		super.update(elapsed);
    Util.checkQuitKey();
    if (FlxG.keys.justPressed.SPACE) {
      FlxG.switchState(new PlayState());
    }
	}

  private function createTitle(): Void {
    titleText = new FlxText(FlxG.width / 2, 100, "Astrofarmer", 64);
    titleText.x -= titleText.width / 2;
    titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.GRAY, 2, 1);
    add(titleText);
  }

  private function createInstructions(): Void {
    startText = new FlxText(FlxG.width / 2, 400, "Press space to start", 16);
    startText.x -= startText.width / 2;
    add(startText);
  }

  private function createKeyHelp(): Void {
    var helpLeft = new FlxText(FlxG.width / 2, 232, "Arrows  :\nSPACEBAR  :\nC  :\nX  : ", 16);
    var helpRight = new FlxText(FlxG.width / 2, 232, " move\n pick up / drop\n strike\n shout", 16);
    helpLeft.alignment = FlxTextAlign.RIGHT;
    helpLeft.x -= helpLeft.width;
    helpRight.alignment = FlxTextAlign.LEFT;
    // helpRight.x -= helpLeft.width / 2;
    add(helpLeft);
    add(helpRight);

  }


}
