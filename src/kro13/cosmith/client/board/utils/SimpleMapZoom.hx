package kro13.cosmith.client.board.utils;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class SimpleMapZoom
{
	private static inline var MIN_SCALE:Float = 1;
	private static inline var MAX_SCALE:Float = 3;
	private static inline var SCALE_STEP:Float = 2000;

	private var map:GameMap;
	private var container:Sprite;
	private var mapScale:Float = 1;

	public function new(map:GameMap)
	{
		this.map = map;
	}

	public function reset()
	{
		map.scaleX = map.scaleY = mapScale = MIN_SCALE;
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

	private function onMouseWheel(e:MouseEvent):Void
	{
		var scaleDelta:Float = e.delta / SCALE_STEP;
		if (mapScale + scaleDelta > MAX_SCALE)
		{
			scaleDelta = MAX_SCALE - mapScale;
		}
		if (mapScale + scaleDelta < MIN_SCALE)
		{
			scaleDelta = -Math.abs(MIN_SCALE - mapScale);
		}
		if (scaleDelta == 0)
		{
			return;
		}

		mapScale += scaleDelta;
		var scaleRatio:Float = mapScale / (mapScale - scaleDelta);
		map.scaleX = map.scaleY = mapScale;

		var mouseX:Float = Lib.current.mouseX / container.scaleX;
		var mouseY:Float = Lib.current.mouseY / container.scaleY;
		var targetX:Float = map.x - (mouseX - map.x) * (scaleRatio - 1);
		var targetY:Float = map.y - (mouseY - map.y) * (scaleRatio - 1);
		var constraintX:Float = (container.width - Lib.current.stage.stageWidth) / container.scaleX;
		var constraintY:Float = (container.height - Lib.current.stage.stageHeight) / container.scaleY;
		targetX = Math.min(0, Math.max(-constraintX, targetX));
		targetY = Math.min(0, Math.max(-constraintY, targetY));
		map.x = targetX;
		map.y = targetY;
	}

	private function doStart():Void
	{
		container = cast map.parent;
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	private function onAdded(e:Event):Void
	{
		doStart();
	}
}
