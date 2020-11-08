package kro13.cosmith.data;

import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TGameObjectComponent;
import kro13.cosmith.data.types.components.TOwnerComponent;
import kro13.cosmith.data.types.components.TRenderComponent;

using kro13.cosmith.data.utils.StructureCombiner;

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
		var map:TGameMap =
			{
				render: newRenderComponent(MAP_IMG),
				objects: []
			}
		map.render.w = width;
		map.render.h = height;
		return map;
	}

	public function newGameObject(id:Int, type:EGameObjectType = NONE):TGameObject
	{
		var template:TGameObject =
			{
				id: id,
				type: type,
				name: "",
				components: []
			};
		template.components.push(newRenderComponent(GO_STUB_IMG));
		return switch (type)
		{
			case PAWN:
				setupPawn(template);
			case NPC:
				setupNPC(template);
			case HERO:
				setupHero(template);
			default:
				template;
		}
	}

	private function setupPawn(tmpl:GameObjectData):TGameObject
	{
		var render:TRenderComponent = tmpl.getComponent(RENDER);
		render.w = render.h = 5;
		tmpl.name = 'Pawn${tmpl.id}';
		return tmpl;
	}

	private function setupNPC(tmpl:GameObjectData):TGameObject
	{
		var render:TRenderComponent = tmpl.getComponent(RENDER);
		render.w = render.h = 2;
		tmpl.name = 'NPC${tmpl.id}';
		return tmpl;
	}

	private function setupHero(tmpl:GameObjectData):TGameObject
	{
		var render:TRenderComponent = tmpl.getComponent(RENDER);
		render.w = render.h = 3;
		tmpl.name = 'Hero${tmpl.id}';
		tmpl.components.push(newOwnerComponent());
		return tmpl;
	}

	private function newOwnerComponent(userId:String = ""):TOwnerComponent
	{
		return {
			type: OWNER,
			userId: userId
		};
	}

	private function newRenderComponent(image:String = GO_STUB_IMG):TRenderComponent
	{
		return {
			type: RENDER,
			image: image,
			x: 0,
			y: 0,
			h: 0,
			w: 0
		};
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
