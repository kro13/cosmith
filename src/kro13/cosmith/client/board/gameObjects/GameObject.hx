package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TRenderComponent;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class GameObject extends GameSprite
{
	public var selectable:Bool = false;
	public var controllable:Bool = false;
	public var data(default, null):GameObjectData;

	public function new(data:TGameObject)
	{
		this.data = data;
		var render:TRenderComponent = this.data.getComponent(RENDER);
		super(render);
	}

	public function handleInteraction(interaction:EGOInteraction):Void
	{
		switch (interaction)
		{
			case NONE:
				handleNone();
			case SELECT:
				handleSelect();
			case UNSELECT:
				handleUnselect();
			case MOVE(x, y):
				handleMove(x, y);
			default:
		}
	}

	private function handleNone():Void
	{
		Messenger.instance.sendCommand('${data.name} does nothing.');
	}

	private function handleSelect():Void
	{
		Messenger.instance.sendCommand('${data.name} selected.');
	}

	private function handleUnselect():Void
	{
		Messenger.instance.sendCommand('${data.name} unselected.');
	}

	private function handleMove(x:Int, y:Int):Void
	{
		Messenger.instance.sendCommand('${data.name} moves to (${x}, ${y}).', MOVE(data.id, x, y));
	}
}

enum EGOInteraction
{
	NONE;
	SELECT;
	UNSELECT;
	MOVE(x:Int, y:Int);
}
