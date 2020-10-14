package kro13.cosmith.client.board;

import kro13.cosmith.client.board.data.types.TGameObject;
import kro13.cosmith.client.board.gameObjects.GameObject;
import kro13.cosmith.client.board.gameObjects.Pawn;

class GameObjectsFactory
{
	public static var instance(get, null):GameObjectsFactory;

	private function new()
	{
	}

	public function buildGameObject(go:TGameObject):GameObject
	{
		var newGO:GameObject;
		switch (go.type)
		{
			case PAWN:
				newGO = new Pawn(go);
			default:
				newGO = new GameObject(go);
		}
		return newGO;
	}

	private static function get_instance():GameObjectsFactory
	{
		if (instance == null)
		{
			instance = new GameObjectsFactory();
		}
		return instance;
	}
}
