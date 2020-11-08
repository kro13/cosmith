package kro13.cosmith.client.board.utils;

import haxe.Timer;
import kro13.cosmith.client.messenger.Messenger;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.ui.Multitouch;

class TouchMapZoom extends SimpleMapZoom implements IMapZoom
{
	private var firstPoint:Point;
	private var secondPoint:Point;
	private var distance:Float;

	override private function startInputListening()
	{
		scaleStep = 500;
		Multitouch.inputMode = TOUCH_POINT;
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
	}

	private function onTouchBegin(e:TouchEvent):Void
	{
		if (firstPoint == null)
		{
			firstPoint = new Point(e.stageX, e.stageY);
			return;
		}
		if (secondPoint == null)
		{
			secondPoint = new Point(e.stageX, e.stageY);
			distance = Point.distance(firstPoint, secondPoint);
			Lib.current.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			isZooming = true;
		}
	}

	private function onTouchEnd(e:TouchEvent):Void
	{
		if (secondPoint != null)
		{
			secondPoint = null;
			Lib.current.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			Lib.current.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			Timer.delay(() -> isZooming = false, 100);
			return;
		}
		if (firstPoint != null)
		{
			firstPoint = null;
		}
	}

	private function onTouchMove(e:TouchEvent):Void
	{
		if (e.touchPointID == 0)
		{
			firstPoint.setTo(e.stageX, e.stageY);
		} else if (e.touchPointID == 1)
		{
			secondPoint.setTo(e.stageX, e.stageY);
		}
	}

	private function onEnterFrame(e:Event):Void
	{
		var newDist:Float = Point.distance(firstPoint, secondPoint);
		var delta:Float = newDist - distance;
		zoom(delta);
		distance = newDist;
	}
}
