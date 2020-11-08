package kro13.cosmith.data.scopes;

import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TGameObjectComponent;
import kro13.cosmith.data.types.components.TRenderComponent;

@:forward
abstract GameObjectData(TGameObject) from TGameObject to TGameObject
{
	public function new(obj:TGameObject)
	{
		this = obj;
	}

	public function getComponent<T:TGameObjectComponent>(type:EGameObjectComponentType):T
	{
		for (c in this.components)
		{
			if (c.type == type)
			{
				return cast c;
			}
		}
		throw 'Component ${type} does not exist in object ${this.id} (${this.name})';
	}

	public function setPosition(x:Int, y:Int):Void
	{
		var render:TRenderComponent = getComponent(RENDER);
		if (render == null)
		{
			return;
		}
		render.x = x;
		render.y = y;
	}
}
