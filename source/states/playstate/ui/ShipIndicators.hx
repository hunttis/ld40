package states.playstate.ui;

import flixel.math.FlxPoint;
import states.playstate.ship.Ship;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar;

class ShipIndicators extends FlxGroup {

  var salesBar: FlxBar;
  var importBar: FlxBar;

  public function new(gameLevel: GameLevel) {
    super();
    salesBar = createBar(0, 0, "arrivalCounter", gameLevel.salesShip);
    salesBar.scrollFactor.set(0, 0);
    importBar = createBar(0, 16, "arrivalCounter", gameLevel.importShip);
    importBar.scrollFactor.set(0,0);
    add(salesBar);
    add(importBar);
  }

  private function createBar(xLoc: Float, yLoc: Float, name: String, ship: Ship): FlxBar {
    var bar: FlxBar = new FlxBar(xLoc, yLoc, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(FlxG.width / 3), 16, ship, name, 0, ship.waitMaximum, true);
    return bar;
  }

}
