package kro13.cosmith.client.board.utils;

import haxe.Timer;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class SimpleMapDrag
{
	public var isDragging(default, null):Bool;

	private var map:GameMap;
	private var container:Sprite;

	public function new(map:GameMap)
	{
		this.map = map;
	}

	public function start()
	{
		if (map.parent != null)
		{
			doStart();
		} else
		{
			map.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
	}

	private function onMouseDown(e:MouseEvent):Void
	{
		var constraintX:Float = (container.width - Lib.current.stage.stageWidth) / container.scaleX;
		var constraintY:Float = (container.height - Lib.current.stage.stageHeight) / container.scaleY;
		map.startDrag(false, new Rectangle(-constraintX, -constraintY, constraintX, constraintY));
		map.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		trace('start drag');
	}

	private function onMouseUp(e:MouseEvent):Void
	{
		map.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		map.stopDrag();
		Timer.delay(() -> isDragging = false, 100);
	}

	private function onMouseMove(e:MouseEvent):Void
	{
		trace(e.delta);
		if (!isDragging)
		{
			isDragging = true;
			trace(isDragging);
		}
	}

	private function doStart():Void
	{
		container = cast map.parent;
		map.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		map.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onAdded(e:Event):Void
	{
		doStart();
	}
}
