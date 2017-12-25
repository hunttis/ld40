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
  @:optional var text: String;
}

class TimedEventTriggers extends FlxGroup {

  public var events: Array<TimedEvent> = [
    { 
      time: 30, occured: false,
      type: TimedEventType.IMPORT_SHIP_ARRIVAL,
      icon: "assets/down.png", text: "Cattle arrives"
    }, {
      time: 31, occured: false,
      type: TimedEventType.IMPORT_SHIP_BEAM
    }, { 
      time: 32, occured: false,
      type: TimedEventType.IMPORT_SHIP_LEAVE
    }, { 
      time: 120, occured: false,
      type: TimedEventType.SALES_SHIP_ARRIVAL,
      icon: "assets/down.png", text: "Sales ship arrives"
    }, { 
      time: 121, occured: false,
      type: TimedEventType.SALES_SHIP_BEAM
    }, { 
      time: 130, occured: false,
      type: TimedEventType.SALES_SHIP_LEAVE,
      icon: "assets/up.png", text: "Sales ship leaves"
    }, {
      time: 140, occured: false,
      type: TimedEventType.GAME_END,
      text: "Game ends"
    }

  ];

  var gameLevel: GameLevel;

  public var currentTime: Float = 0;

  public function new(gameLevel: GameLevel) {
    super();
    this.gameLevel = gameLevel;
  }  

  override public function update(elapsed: Float) {
    super.update(elapsed);
    currentTime += elapsed;

    var triggeredEvents: Array<TimedEvent> = events.filter(function(event) {
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
      case TimedEventType.GAME_END: gameLevel.levelFinished();
      default: trace("Undefined event trigger!" + type);
    }

  }

  

}