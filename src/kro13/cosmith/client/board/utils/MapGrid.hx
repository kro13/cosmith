package kro13.cosmith.client.board.utils;

import kro13.cosmith.data.scopes.MapData;
import openfl.display.Sprite;

class MapGrid extends Sprite
{
	private var tileSize:Int = MapData.TILE_SIZE;
	private var w:Int;
	private var h:Int;

	public function new()
	{
		super();
	}

	public function redraw(w:Int, h:Int):Void
	{
		if (this.w == w && this.h == h)
		{
			return;
		}
		trace('redraw ${w} ${h}');
		this.w = w;
		this.h = h;
		graphics.clear();
		graphics.lineStyle(0, 0x343a40, 1);
		for (i in 0...Math.round(w / tileSize))
		{
			graphics.moveTo(i * tileSize, 0);
			graphics.lineTo(i * tileSize, h);
		}
		for (i in 0...Math.round(h / tileSize))
		{
			graphics.moveTo(0, i * tileSize);
			graphics.lineTo(w, i * tileSize);
		}
	}
}
