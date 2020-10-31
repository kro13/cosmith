package kro13.cosmith.client.board.gameObjects;

class Pawn extends GameObject
{
	override public function start():Void
	{
		super.start();
		setOrigin(-0.5, -0.5);
		selectable = true;
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
}
