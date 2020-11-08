package kro13.cosmith.client.board.utils;

import haxe.Timer;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class SimpleMapDrag implements IMapDrag
{
	public var isDragging(default, null):Bool;

	private var map:GameMap;
	private var container:Sprite;
	private var mouseX:Float;
	private var mouseY:Float;
	private var threshold:Float = 10;

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
		mouseX = Lib.current.mouseX;
		mouseY = Lib.current.mouseY;
		map.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function onMouseUp(e:MouseEvent):Void
	{
		if (isDragging)
		{
			map.stopDrag();
			Timer.delay(() -> isDragging = false, 100);
		}
		map.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	private function onMouseMove(e:MouseEvent):Void
	{
		var delta:Float = Math.sqrt((mouseX - Lib.current.mouseX) * (mouseX - Lib.current.mouseX)
			+ (mouseY - Lib.current.mouseY) * (mouseY - Lib.current.mouseY));
		if (delta > threshold)
		{
			startDrag();
		}
	}

	private function startDrag():Void
	{
		var constraintX:Float = (container.width - Lib.current.stage.stageWidth) / container.scaleX;
		var constraintY:Float = (container.height - Lib.current.stage.stageHeight) / container.scaleY;
		map.startDrag(false, new Rectangle(-constraintX, -constraintY, constraintX, constraintY));
		isDragging = true;
		map.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
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
