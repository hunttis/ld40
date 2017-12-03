package states.playstate;

import flixel.group.FlxGroup;

class ItemGroup extends FlxGroup {
  public var foods(default, null): FlxTypedGroup<Food>;
  public var weapons(default, null): FlxTypedGroup<Weapon>;
  public var seeds(default, null): FlxTypedGroup<Seed>;

  public function new() {
    super();
    foods = new FlxTypedGroup();
    weapons = new FlxTypedGroup();
    seeds = new FlxTypedGroup();

    add(foods);
    add(weapons);
    add(seeds);
  }
}
