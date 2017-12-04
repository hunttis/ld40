package states.playstate.ui;

import flixel.text.FlxText;
import flixel.math.FlxPoint;
import states.playstate.ship.Ship;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar;

class ShipIndicators extends FlxGroup {
  var salesBar: FlxBar;
  var importBar: FlxBar;

  var salesText: FlxText;
  var importText: FlxText;

  public function new(gameLevel: GameLevel) {
    super();
    salesBar = createBar(0, 0, "arrivalCounter", gameLevel.salesShip);
    salesBar.scrollFactor.set(0, 0);
    salesText = createText("Incoming Sales Ship", 0);
    salesText.scrollFactor.set(0,0);

    importBar = createBar(0, 16, "arrivalCounter", gameLevel.importShip);
    importBar.scrollFactor.set(0,0);
    importText = createText("Incoming Cattle Ship", 16);
    importText.scrollFactor.set(0,0);

    add(salesBar);
    add(salesText);
    add(importBar);
    add(importText);
  }

  private function createBar(xLoc: Float, yLoc: Float, name: String, ship: Ship): FlxBar {
    var bar: FlxBar = new FlxBar(xLoc, yLoc, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(FlxG.width / 3), 16, ship, name, 0, ship.waitMaximum, true);
    return bar;
  }

  private function createText(name: String, yLoc: Int): FlxText {
    return new FlxText(Math.floor(FlxG.width / 3) + 2, yLoc, 0, name, 12, true);
  }
}
