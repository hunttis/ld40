package states.playstate.ui;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar;
import states.playstate.TimedEventTriggers.TimedEvent;
import flixel.text.FlxText;

class EventIndicator extends FlxGroup {

  var eventBar: FlxBar;
  var events: Array<TimedEvent>;
  var timeText: FlxText;
  var eventText: FlxText;

  public function new(gameLevel: GameLevel) {
    super();

    events = gameLevel.timedEventTriggers.events;

    var lastEvent = events[events.length - 1];
    var gameEndTime = lastEvent.time;

    eventBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 16, gameLevel.timedEventTriggers, "currentTime", 0, gameEndTime, false);
    eventBar.scrollFactor.set(0, 0);
    eventBar.numDivisions = Math.floor(lastEvent.time) * 10;
    add(eventBar);

    var timeUnit: Float = FlxG.width / gameEndTime;
    
    for (event in events) {
      if (event.icon != null) {
        var icon: FlxSprite = new FlxSprite();
        icon.loadGraphic(event.icon);
        icon.scrollFactor.set(0, 0);
        icon.x = Math.floor(timeUnit * event.time + 8);
        icon.y = 8;
        trace("Adding icon for: " + event.type + " to " + icon.x + "/" + icon.y); 
        add(icon);
      }
    }

    timeText = new FlxText(0, 0, 0, "Time", 12, true);
    timeText.scrollFactor.set(0, 0);
    timeText.color = FlxColor.BLACK; 
    timeText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1, 0);
    add(timeText);

    eventText = new FlxText(0, 32, 0, "Next event on timeline: ", 12, true);
    eventText.scrollFactor.set(0, 0);
    eventText.color = FlxColor.BLACK; 
    eventText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1, 0);
    add(eventText);
  }

  override public function update(elapsed: Float): Void {
    
    var nextEvent: TimedEvent = null;

    for (event in events) {
      if (nextEvent == null && !event.occured && event.text != null) {
        nextEvent = event;
      }
    }
    
    if (nextEvent != null) {
      var nextEventText = "Next event on timeline: " + nextEvent.text;

      if (eventText.text != nextEventText) {
        eventText.text = nextEventText;
      }
    }

    super.update(elapsed);
  }

}