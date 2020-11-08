package kro13.cosmith.client.board.utils;

import openfl.Lib;
import openfl.events.TouchEvent;
import openfl.ui.Multitouch;

class TouchMapDrag extends SimpleMapDrag implements IMapDrag
{
	var zoom:TouchMapZoom;
	var touchCount:Int = 0;

	override public function start():Void
	{
		super.start();
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
	}

	override private function startDrag():Void
	{
		if (touchCount < 2)
		{
			super.startDrag();
		}
	}

	private function onTouchBegin(e:TouchEvent):Void
	{
		touchCount++;
	}

	private function onTouchEnd(e:TouchEvent):Void
	{
		touchCount--;
	}
}
