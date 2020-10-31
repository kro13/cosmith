package kro13.cosmith.client.board.gameObjects;

import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.TGameObject;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class GameObject extends Sprite implements IUpdatable
{
	public var w(default, null):Int = 0;
	public var h(default, null):Int = 0;
	public var wTiles(get, null):Int;
	public var hTiles(get, null):Int;
	public var xTiles(get, set):Int;
	public var yTiles(get, set):Int;
	public var selectable:Bool = false;
	public var movable:Bool = false;

	private var data:TGameObject;
	private var bmpData:Bitmap;

	public function new(data:TGameObject)
	{
		super();
		this.data = data;
	}

	public function start():Void
	{
		bmpData = new Bitmap(Assets.getBitmapData(data.image));
		addChild(bmpData);
		resizeTiles(data.w, data.h);
		positionTiles(data.x, data.y);

		Updater.instance.add(this);
	}

	public function update(dt:Float):Void
	{
		resizeTiles(data.w, data.h);
		positionTiles(data.x, data.y);
	}

	public function setOrigin(byX:Float, byY:Float)
	{
		if (bmpData != null)
		{
			bmpData.x = bmpData.width * byX;
			bmpData.y = bmpData.height * byY;
		}
	}

	public function handleInteraction(interaction:EGOInteraction):Void
	{
		switch (interaction)
		{
			case NONE:
				handleNone();
			case SELECT:
				handleSelect();
			case UNSELECT:
				handleUnselect();
			case MOVE(x, y):
				handleMove(x, y);
			default:
		}
	}

	private function positionTiles(x:Int, y:Int):Void
	{
		xTiles = x;
		yTiles = y;
	}

	private function resizeTiles(w:Int, h:Int):Void
	{
		resize(w * MapData.TILE_SIZE, h * MapData.TILE_SIZE);
	}

	private function resize(w:Int, h:Int):Void
	{
		if (this.w == w && this.h == h)
		{
			return;
		}
		if (bmpData != null)
		{
			bmpData.width = w;
			bmpData.height = h;
		}
		this.w = w;
		this.h = h;

		trace('resize ${w} ${h}');
	}

	private function handleNone():Void
	{
		Messenger.instance.sendCommand('${data.name} does nothing.');
	}

	private function handleSelect():Void
	{
		Messenger.instance.sendCommand('${data.name} selected.');
	}

	private function handleUnselect():Void
	{
		Messenger.instance.sendCommand('${data.name} unselected.');
	}

	private function handleMove(x:Int, y:Int):Void
	{
		Messenger.instance.sendCommand('${data.name} moves to (${x}, ${y}).');
	}

	private function get_wTiles():Int
	{
		return Math.ceil(w / MapData.TILE_SIZE);
	}

	private function get_hTiles():Int
	{
		return Math.ceil(h / MapData.TILE_SIZE);
	}

	private function get_xTiles():Int
	{
		return Math.ceil(x / MapData.TILE_SIZE);
	}

	private function get_yTiles():Int
	{
		return Math.ceil(y / MapData.TILE_SIZE);
	}

	private function set_xTiles(x:Int):Int
	{
		this.x = (x - 0.5) * MapData.TILE_SIZE; // align by tile center
		return x;
	}

	private function set_yTiles(y:Int):Int
	{
		this.y = (y - 0.5) * MapData.TILE_SIZE; // align by tile center
		return y;
	}
}

enum EGOInteraction
{
	NONE;
	SELECT;
	UNSELECT;
	MOVE(x:Int, y:Int);
}
