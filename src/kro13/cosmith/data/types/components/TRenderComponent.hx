package kro13.cosmith.data.types.components;

import kro13.cosmith.data.types.components.TGameObjectComponent;

typedef TRenderComponent =
{
	> TGameObjectComponent,
	var image:String;
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}
