package kro13.cosmith.data.types;

typedef TGameObject =
{
	var id:Int;
	var type:EGameObjectType;
	var image:String;
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
	var name:String;
}

typedef THero =
{
	> TGameObject,
	userId:String
}

enum abstract EGameObjectType(Int)
{
	var NONE = 0;
	var PAWN = 1;
	var HERO = 2;
	var NPC = 3;
}
