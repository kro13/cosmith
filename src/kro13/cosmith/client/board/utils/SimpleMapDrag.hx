package kro13.cosmith.client.board.utils;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class SimpleMapDrag
{
	private var map:GameMap;
	private var container:Sprite;

	public function new(map:GameMap, container:Sprite)
	{
		this.map = map;
		this.container = container;
	}

	public function start()
	{
		map.addEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
		map.addEventListener(MouseEvent.MOUSE_UP, onTargetMouseUp);
	}

	private function onTargetMouseDown(e:MouseEvent):Void
	{
		var constraintX:Float = (container.width - Lib.current.stage.stageWidth) / container.scaleX;
		var constraintY:Float = (container.height - Lib.current.stage.stageHeight) / container.scaleY;
		map.startDrag(false, new Rectangle(-constraintX, -constraintY, constraintX, constraintY));
	}

	private function onTargetMouseUp(e:MouseEvent):Void
	{
		map.stopDrag();
	}
}
