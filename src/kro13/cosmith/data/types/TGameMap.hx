package kro13.cosmith.data.types;

import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TRenderComponent;

typedef TGameMap =
{
	var render:TRenderComponent;
	var objects:Array<TGameObject>;
};
