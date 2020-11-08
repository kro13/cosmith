package kro13.cosmith.data;

import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.ECommand;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.components.TRenderComponent;
import kro13.cosmith.data.types.components.TRevealedComponent;

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
				var data:GameObjectData = map.getObjectById(id);
				var render:TRenderComponent = data.getComponent(RENDER);
				render.x = x;
				render.y = y;

			case HIT(id, targetId):
				map.removeObject(map.getObjectById(targetId));

			case REVEAL(id, targetId):
				var hero:GameObjectData = map.getObjectById(id);
				var revealed:TRevealedComponent = hero.getComponent(REVEALED);
				if (revealed.ids.indexOf(targetId) < 0)
				{
					revealed.ids.push(targetId);
				}

			case NONE:

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
