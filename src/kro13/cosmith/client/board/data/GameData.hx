package kro13.cosmith.client.board.data;

import kro13.cosmith.client.board.data.scopes.GameObjectData.GameObectData;
import kro13.cosmith.client.board.data.scopes.MapData;

class GameData
{
	public static var instance(get, null):GameData;

	public var map(default, null):MapData;
	public var go(default, null):GameObectData;

	private function new()
	{
		map = new MapData();
		go = new GameObectData();
	}

	public function init()
	{
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
