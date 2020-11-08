package kro13.cosmith.data.scopes;

import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TOwnerComponent;
import kro13.cosmith.data.types.components.TRenderComponent;

class MapData
{
	public static inline var TILE_SIZE:Int = 10;

	public var data(default, null):TGameMap;
	public var objects(default, null):Array<GameObjectData>;

	private var idsToObjects:Map<Int, GameObjectData>;
	private var userIdsToHeroes:Map<String, GameObjectData>;

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

	public function getHeroByUserId(userId:String):TGameObject
	{
		return userIdsToHeroes.get(userId);
	}

	public function getObjectsOnSameTile(object:GameObjectData):Array<TGameObject>
	{
		var result:Array<TGameObject> = [];
		var render:TRenderComponent = object.getComponent(RENDER);
		for (obj in objects)
		{
			var objRender:TRenderComponent = obj.getComponent(RENDER);
			if (render.x == objRender.x && render.y == objRender.y && obj.id != object.id)
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

	private function addToIndex(obj:GameObjectData):Void
	{
		idsToObjects.set(obj.id, obj);
		if (obj.type == HERO)
		{
			var owner:TOwnerComponent = obj.getComponent(OWNER);
			userIdsToHeroes.set(owner.userId, obj);
		}
	}

	private function removeFromIndex(obj:GameObjectData):Void
	{
		idsToObjects.remove(obj.id);
		if (obj.type == HERO)
		{
			var owner:TOwnerComponent = obj.getComponent(OWNER);
			userIdsToHeroes.remove(owner.userId);
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
