package kro13.cosmith.data;

import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;

class GameDataFactory
{
	public static var instance(get, null):GameDataFactory;

	private static inline var GO_STUB_IMG:String = "images/go_stub.png";
	private static inline var MAP_IMG:String = "images/map_test.jpg";

	public function new()
	{
	}

	public function newMap(width:Int, height:Int):TGameMap
	{
		var map:TGameMap = cast newGameObject(-1);
		map.w = width;
		map.h = height;
		map.image = MAP_IMG;
		map.objects = [];
		map.name = "Map";
		return map;
	}

	public function newGameObject(id:Int, type:EGameObjectType = NONE):TGameObject
	{
		var template:TGameObject =
			{
				id: id,
				type: type,
				image: GO_STUB_IMG,
				x: 0,
				y: 0,
				w: 0,
				h: 0,
				name: ""
			};

		switch (type)
		{
			case PAWN:
				setupPawn(template);
			case NPC:
				setupNPC(template);
			case HERO:
				setupHero(template);
			default:
		}

		return template;
	}

	private function setupPawn(tmpl:TGameObject):Void
	{
		tmpl.w = tmpl.h = 5;
		tmpl.name = 'Pawn${tmpl.id}';
	}

	private function setupNPC(tmpl:TGameObject):Void
	{
		tmpl.w = tmpl.h = 2;
		tmpl.name = 'NPC${tmpl.id}';
	}

	private function setupHero(tmpl:TGameObject):Void
	{
		tmpl.w = tmpl.h = 3;
		tmpl.name = 'Hero${tmpl.id}';
	}

	private static function get_instance():GameDataFactory
	{
		if (instance == null)
		{
			instance = new GameDataFactory();
		}
		return instance;
	}
}