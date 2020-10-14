package kro13.cosmith.client.board.data.scopes;

import kro13.cosmith.client.board.data.types.TGameObject;

class MapData
{
	public static inline var TILE_SIZE:Int = 10;

	public var objects(default, null):Array<TGameObject>;

	private var idsToObjects:Map<Int, TGameObject>;

	public function new()
	{
		objects = [];
		idsToObjects = new Map();
	}

	public function addObject(object:TGameObject):Void
	{
		objects.push(object);
		idsToObjects.set(object.id, object);
	}

	public function removeObject(object:TGameObject):Void
	{
		objects.remove(object);
		idsToObjects.remove(object.id);
	}

	public function objectExists(id:Int):Bool
	{
		return idsToObjects.exists(id);
	}

	// debug
	public function printObjects():Void
	{
		for (obj in objects)
		{
			trace(obj);
		}
	}
}
