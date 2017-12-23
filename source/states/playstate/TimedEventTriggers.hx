package states.playstate;

import flixel.group.FlxGroup;

enum TimedEventType {
  IMPORT_SHIP_ARRIVAL;
  IMPORT_SHIP_BEAM;
  IMPORT_SHIP_LEAVE;
  SALES_SHIP_ARRIVAL;
  SALES_SHIP_BEAM;
  SALES_SHIP_LEAVE;
  GAME_END;
}

typedef TimedEvent = { 
  var time: Float;
  var occured: Bool;
  var type: TimedEventType;
  @:optional var icon: String;
}

class TimedEventTriggers extends FlxGroup {

  public var events: Array<TimedEvent> = [
    { 
      time: 10, occured: false,
      type: TimedEventType.IMPORT_SHIP_ARRIVAL,
      icon: "assets/down.png"
    }, {
      time: 11, occured: false,
      type: TimedEventType.IMPORT_SHIP_BEAM
    }, { 
      time: 13, occured: false,
      type: TimedEventType.IMPORT_SHIP_LEAVE,
      icon: "assets/up.png"
    }, { 
      time: 15, occured: false,
      type: TimedEventType.SALES_SHIP_ARRIVAL,
      icon: "assets/down.png"
    }, { 
      time: 16, occured: false,
      type: TimedEventType.SALES_SHIP_BEAM
    }, { 
      time: 17, occured: false,
      type: TimedEventType.SALES_SHIP_LEAVE,
      icon: "assets/up.png"
    }, {
      time: 20, occured: false,
      type: TimedEventType.GAME_END
    }

  ];

  public static inline var TIMELINE_TOTAL: Float = 130;

  var gameLevel: GameLevel;

  public var currentTime: Float = 0;

  public function new(gameLevel: GameLevel) {
    super();
    this.gameLevel = gameLevel;
  }  

  override public function update(elapsed: Float) {
    super.update(elapsed);
    currentTime += elapsed;
    // trace(currentTime);

    var triggeredEvents: Array<TimedEvent> = events.filter(function(event) {
      // trace("Event should occur: " + event.type + ": " + (!event.occured && event.time < currentTime));
      return !event.occured && event.time < currentTime;
    });

    for (event in triggeredEvents) {
      triggerEvent(event.type);
      event.occured = true;
    }
  }

  private function triggerEvent(type: TimedEventType) {
    
    switch type {
      case TimedEventType.IMPORT_SHIP_ARRIVAL: gameLevel.importShip.arrive();
      case TimedEventType.IMPORT_SHIP_BEAM: gameLevel.importShip.action();
      case TimedEventType.IMPORT_SHIP_LEAVE: gameLevel.importShip.leave();
      case TimedEventType.SALES_SHIP_ARRIVAL: gameLevel.salesShip.arrive();
      case TimedEventType.SALES_SHIP_BEAM: gameLevel.salesShip.action();
      case TimedEventType.SALES_SHIP_LEAVE: gameLevel.salesShip.leave();
      default: trace("Undefined event trigger!" + type);
    }

  }

}