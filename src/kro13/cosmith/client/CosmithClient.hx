package kro13.cosmith.client;

import kro13.cosmith.client.board.Board;
import kro13.cosmith.client.board.Updater;
import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.client.ui.MainUI;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.GameDataFactory;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.TMessage;

class CosmithClient
{
	public function new()
	{
	}

	public function start():Void
	{
		Remote.instance.loadMap(onMapLoaded, onRemoteError);
	}

	private function onMapLoaded(map:TGameMap):Void
	{
		GameData.instance.init(map);
		// GameData.instance.map.printObjects();
		startMessenger();
		startBoard();
		startUI();
		Updater.instance.start();
	}

	private function startBoard():Void
	{
		new Board().start();
	}

	private function startUI():Void
	{
		new MainUI().start();
	}

	private function startMessenger():Void
	{
		Messenger.instance.start();
		Messenger.instance.onReceive.add(onMessageReceive);
	}

	private function onMessageReceive(message:TMessage):Void
	{
		switch (message.type)
		{
			case COMMAND(command):
				switch (command)
				{
					case SPAWN(id, type, x, y, name):
						var data:TGameObject = GameDataFactory.instance.newGameObject(id, type);
						data.x = x;
						data.y = y;
						data.name = name;
						GameData.instance.map.addObject(data);

					default:
						trace('Command ${command}');
				}
			default:
		}
	}

	private function onRemoteError(e:Dynamic):Void
	{
		trace('Remote error: ${e}');
	}
}
