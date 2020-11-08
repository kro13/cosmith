package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TOwnerComponent;

class Hero extends Pawn
{
	public function new(data:TGameObject)
	{
		super(data);
		var owner:TOwnerComponent = this.data.getComponent(OWNER);
		controllable = Messenger.instance.isMine(owner.userId);
	}

	override private function handleMove(x:Int, y:Int)
	{
		super.handleMove(x, y);
		for (go in GameData.instance.map.getObjectsOnSameTile(data))
		{
			Messenger.instance.sendCommand('${data.name} hits ${go.name}');
		}
	}
}
