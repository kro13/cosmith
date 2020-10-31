package kro13.cosmith.data.scopes;

import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;

class MapData
{
	public static inline var TILE_SIZE:Int = 10;

	public var data(default, null):TGameMap;
	public var objects(default, null):Array<TGameObject>;

	private var idsToObjects:Map<Int, TGameObject>;

	public function new(data:TGameMap)
	{
		this.data = data;
		objects = data.objects;
		buildIndex();
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

	public function getObjectsOnSameTile(object:TGameObject):Array<TGameObject>
	{
		var result:Array<TGameObject> = [];
		for (obj in objects)
		{
			if (obj.x == object.x && obj.y == object.y && obj.id != object.id)
			{
				result.push(obj);
			}
		}
		return result;
	}

	private function buildIndex():Void
	{
		idsToObjects = new Map();
		for (obj in objects)
		{
			idsToObjects.set(obj.id, obj);
		}
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
