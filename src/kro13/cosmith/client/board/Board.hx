package kro13.cosmith.client.board;

import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.GameDataFactory;
import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.types.ECommand;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.TMessage;
import kro13.cosmith.data.types.components.TOwnerComponent;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

class Board extends Sprite implements IUpdatable
{
	private static inline var MIN_W:Float = 1920;
	private static inline var MIN_H:Float = 1080;
	private static inline var MAP_IMG:String = "images/map_test.jpg";

	private var map:GameMap;

	public function new()
	{
		super();
	}

	public function start():Void
	{
		var mapData:TGameMap = GameData.instance.map.data;
		map = new GameMap(mapData);
		map.start();
		this.addChild(map);
		Lib.current.addChild(this);

		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		Messenger.instance.onReceive.add(onMessageReceive);
		Updater.instance.add(this);
	}

	public function update(dt:Float):Void
	{
	}

	private function onMessageReceive(message:TMessage):Void
	{
		switch (message.type)
		{
			case COMMAND(command):
				GameData.instance.process(command);
				switch (command)
				{
					case SPAWN(data):
						trySetMyHero(data);
					default:
				}

			default:
		}
	}

	private function trySetMyHero(data:GameObjectData):Void
	{
		if (map.myHero != null || data.type != HERO)
		{
			return;
		}
		var owner:TOwnerComponent = data.getComponent(OWNER);
		if (Messenger.instance.isMine(owner.userId))
		{
			map.myHero = data;
		}
	}

	private function resize():Void
	{
		var w:Float = Math.max(MIN_W, Lib.current.stage.stageWidth);
		var h:Float = Math.max(MIN_H, Lib.current.stage.stageHeight);
		var scale:Float = Math.max(w / map.w, h / map.h);
		scaleX = scaleY = scale;
		// trace('scale ${scale}');
	}

	private function onResize(e:Event):Void
	{
		resize();
		map.x = map.y = 0;
	}
}
