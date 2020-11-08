package kro13.cosmith.data.types;

import kro13.cosmith.data.types.TGameObject.EGameObjectType;
import kro13.cosmith.data.types.TGameObject;

enum ECommand
{
	NONE;
	SPAWN(data:TGameObject);
	MOVE(id:Int, x:Int, y:Int);
}
