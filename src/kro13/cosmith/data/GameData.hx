package kro13.cosmith.data;

import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.ECommand;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;

class GameData
{
	public static var instance(get, null):GameData;

	public var map(default, null):MapData;

	private function new()
	{
	}

	public function init(map:TGameMap):Void
	{
		this.map = new MapData(map);
	}

	public function process(command:ECommand):Void
	{
		switch (command)
		{
			case SPAWN(data):
				map.addObject(data);

			case MOVE(id, x, y):
				var data:TGameObject = map.getObjectById(id);
				data.x = x;
				data.y = y;

			default:
				trace('No handler for ${command}');
		}
	}

	private static function get_instance():GameData
	{
		if (instance == null)
		{
			instance = new GameData();
		}
		return instance;
	}
}
