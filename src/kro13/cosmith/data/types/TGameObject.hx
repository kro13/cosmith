package kro13.cosmith.data.types;

import kro13.cosmith.data.types.components.TGameObjectComponent;

typedef TGameObject =
{
	var id:Int;
	var type:EGameObjectType;
	var name:String;
	var components:Array<TGameObjectComponent>;
}

enum abstract EGameObjectType(String) from String to String
{
	var NONE = "none";
	var PAWN = "pawn";
	var HERO = "hero";
	var NPC = "npc";
}
