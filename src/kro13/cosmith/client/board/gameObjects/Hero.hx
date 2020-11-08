package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.board.utils.MathUtils;
import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TOwnerComponent;
import kro13.cosmith.data.types.components.TStatsComponent;

class Hero extends Pawn
{
	private var stats:TStatsComponent;

	public function new(data:TGameObject)
	{
		super(data);
		var owner:TOwnerComponent = this.data.getComponent(OWNER);
		controllable = Messenger.instance.isMine(owner.userId);
		stats = this.data.getComponent(STATS);
	}

	override private function handleMove(x:Int, y:Int)
	{
		trace(MathUtils.distanceInt(render.x, render.y, x, y));
		trace(stats.movementPoints);
		if (MathUtils.distanceInt(render.x, render.y, x, y) > stats.movementPoints)
		{
			Messenger.instance.sendCommand('${data.name} can not go that far.');
			return;
		}
		super.handleMove(x, y);
		for (go in GameData.instance.map.getObjectsOnSameTile(data))
		{
			Messenger.instance.sendCommand('${data.name} hits ${go.name}');
		}
	}
}
