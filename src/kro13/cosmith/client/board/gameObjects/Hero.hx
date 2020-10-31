package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.types.TGameObject;

class Hero extends Pawn
{
	public function new(data:TGameObject)
	{
		super(data);
		movable = true;
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
