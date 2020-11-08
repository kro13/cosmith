package kro13.cosmith.data.types.components;

typedef TGameObjectComponent =
{
	type:EGameObjectComponentType
}

enum abstract EGameObjectComponentType(String) from String to String
{
	var OWNER = "owner";
	var RENDER = "render";
	var STATS = "stats";
}
