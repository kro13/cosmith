package kro13.cosmith.data.types;

import kro13.cosmith.data.types.TGameObject;

typedef TGameMap =
{
	> TGameObject,
	var objects:Array<TGameObject>;
};
