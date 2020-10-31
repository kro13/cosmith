package kro13.cosmith.client.board;

import kro13.cosmith.client.board.gameObjects.GameObject;
import kro13.cosmith.client.board.gameObjects.Hero;
import kro13.cosmith.client.board.gameObjects.NPC;
import kro13.cosmith.client.board.gameObjects.Pawn;
import kro13.cosmith.data.types.TGameObject;

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
			case NPC:
				newGO = new NPC(go);
			case HERO:
				newGO = new Hero(go);

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
