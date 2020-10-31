package kro13.cosmith.data;

import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.TGameMap;

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

	private static function get_instance():GameData
	{
		if (instance == null)
		{
			instance = new GameData();
		}
		return instance;
	}
}
