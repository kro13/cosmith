package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.messenger.Messenger;

class Pawn extends GameObject
{
	override public function start():Void
	{
		super.start();
		setOrigin(-0.5, -0.5);
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);
		if (parent != null)
		{
			this.scaleX = 1 / parent.scaleX;
			this.scaleY = 1 / parent.scaleY;
		}
	}

	override private function handleClick():Void
	{
		Messenger.instance.send({userId: Messenger.ID_NONE, text: 'Pawn ${data.id} selected.'});
	}

	override private function handleClickOutside():Void
	{
		Messenger.instance.send({userId: Messenger.ID_NONE, text: 'Pawn ${data.id} unselected.'});
	}

	override private function handleMove(x:Int, y:Int):Void
	{
		Messenger.instance.send({userId: Messenger.ID_NONE, text: 'Pawn ${data.id} goes to (${x}, ${y}).'});
	}
}
