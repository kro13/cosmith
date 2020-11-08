package kro13.cosmith.data.scopes;

import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;

class MapData
{
	public static inline var TILE_SIZE:Int = 10;

	public var data(default, null):TGameMap;
	public var objects(default, null):Array<TGameObject>;

	private var idsToObjects:Map<Int, TGameObject>;
	private var userIdsToHeroes:Map<String, THero>;

	public function new(data:TGameMap)
	{
		this.data = data;
		objects = data.objects;
		buildIndex();
	}

	public function addObject(object:TGameObject):Void
	{
		objects.push(object);
		addToIndex(object);
	}

	public function removeObject(object:TGameObject):Void
	{
		objects.remove(object);
		removeFromIndex(object);
	}

	public function objectExists(id:Int):Bool
	{
		return idsToObjects.exists(id);
	}

	public function getObjectById(id:Int):TGameObject
	{
		return idsToObjects.get(id);
	}

	public function getHeroByUserId(userId:String):THero
	{
		return userIdsToHeroes.get(userId);
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
		userIdsToHeroes = new Map();
		for (obj in objects)
		{
			addToIndex(obj);
		}
	}

	private function addToIndex(obj:TGameObject):Void
	{
		idsToObjects.set(obj.id, obj);
		if (obj.type == HERO)
		{
			var hero:THero = cast obj;
			userIdsToHeroes.set(hero.userId, hero);
		}
	}

	private function removeFromIndex(obj:TGameObject):Void
	{
		idsToObjects.remove(obj.id);
		if (obj.type == HERO)
		{
			var hero:THero = cast obj;
			userIdsToHeroes.remove(hero.userId);
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
