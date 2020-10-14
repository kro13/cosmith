package kro13.cosmith.client.board.data.scopes;

import kro13.cosmith.client.board.data.types.TGameObject;

class GameObectData
{
	private static inline var STUB_IMG:String = "images/go_stub.png";

	private static var ids:Int;

	public function new()
	{
		ids = 0;
	}

	public function newGameObject(type:EGameObjectType = NONE):TGameObject
	{
		var template:TGameObject =
			{
				id: ids++,
				type: type,
				image: STUB_IMG,
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
			default:
		}

		return template;
	}

	private function setupPawn(tmpl:TGameObject):Void
	{
		tmpl.w = tmpl.h = 5;
		tmpl.name = 'Pawn${tmpl.id}';
	}
}
