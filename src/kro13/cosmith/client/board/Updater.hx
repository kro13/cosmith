package kro13.cosmith.client.board;

import haxe.Timer;
import openfl.Lib;
import openfl.events.Event;

class Updater
{
	public static var instance(get, null):Updater;

	private var updatables:Array<IUpdatable>;
	private var lastStamp:Float;
	private var delta:Float = 1 / 60;

	private function new()
	{
		updatables = [];
	}

	public function start():Void
	{
		lastStamp = Timer.stamp();
		Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	public function add(updatable:IUpdatable):Void
	{
		updatables.push(updatable);
	}

	public function remove(updatable:IUpdatable):Void
	{
		updatables.remove(updatable);
	}

	private function onEnterFrame(e:Event):Void
	{
		var stamp:Float = Timer.stamp();
		if (stamp - lastStamp >= delta)
		{
			for (u in updatables)
			{
				u.update(stamp - lastStamp);
			}
			lastStamp = stamp;
		}
	}

	private static function get_instance():Updater
	{
		if (instance == null)
		{
			instance = new Updater();
		}
		return instance;
	}
}
