package kro13.cosmith.data.types;

import kro13.cosmith.data.types.TGameObject.EGameObjectType;

enum ECommand
{
	NONE;
	SPAWN(id:Int, type:EGameObjectType, x:Int, y:Int, ?name:String);
	MOVE(id:Int, x:Int, y:Int);
}
