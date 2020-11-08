package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.board.utils.MathUtils;
import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TRenderComponent;
import kro13.cosmith.data.types.components.TRevealedComponent;
import kro13.cosmith.data.types.components.TStatsComponent;

class Hero extends Pawn
{
	private var stats:TStatsComponent;
	private var revealed:TRevealedComponent;

	public function new(data:TGameObject)
	{
		super(data);
		stats = this.data.getComponent(STATS);
		revealed = this.data.getComponent(REVEALED);
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
		for (go in GameData.instance.map.objects)
		{
			if (go.id == data.id)
			{
				continue;
			}
			var goRender:TRenderComponent = go.getComponent(RENDER);
			if (go.type != HERO
				&& revealed.ids.indexOf(go.id) < 0
				&& MathUtils.distanceInt(x, y, goRender.x, goRender.y) <= stats.visionRange)
			{
				Messenger.instance.sendCommand('${data.name} reveals ${go.name}', REVEAL(data.id, go.id));
			}
			if (MathUtils.distanceInt(x, y, goRender.x, goRender.y) == 0)
			{
				Messenger.instance.sendCommand('${data.name} hits ${go.name}', HIT(data.id, go.id));
			}
		}
	}
}
