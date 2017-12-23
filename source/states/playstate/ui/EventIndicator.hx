package states.playstate.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar;
import states.playstate.TimedEventTriggers.TimedEvent;
import states.playstate.TimedEventTriggers.TimedEventType;

class EventIndicator extends FlxGroup {

  var eventBar: FlxBar;
  var events: Array<TimedEvent>;

  public function new(gameLevel: GameLevel) {
    super();

    events = gameLevel.timedEventTriggers.events;

    var lastEvent = events[events.length - 1];
    var gameEndTime = lastEvent.time;

    eventBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 16, gameLevel.timedEventTriggers, "currentTime", 0, gameEndTime, true);
    eventBar.scrollFactor.set(0, 0);
    add(eventBar);

    var timeUnit: Int = Math.floor(FlxG.width / gameEndTime);
    
    for (event in events) {
      if (event.icon != null) {
        var icon: FlxSprite = new FlxSprite();
        icon.loadGraphic(event.icon);
        icon.x = timeUnit * event.time;
        icon.y = 16;
        icon.scrollFactor.set(0, 0);
        trace("Adding icon for: " + event.type + " to " + icon.x + "/" + icon.y); 
        add(icon);
      }
    }

  }

  // private function createBar(xLoc: Float, yLoc: Float, name: String, ship: Ship): FlxBar {
  //   var bar: FlxBar = new FlxBar(xLoc, yLoc, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(FlxG.width / 3), 16, ship, name, 0, ship.waitMaximum, true);
  //   return bar;
  // }

}