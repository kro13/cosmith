package kro13.cosmith.client;

import kro13.cosmith.client.board.Board;
import kro13.cosmith.client.board.Updater;
import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.client.ui.MainUI;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.types.TGameMap;

class CosmithClient
{
	public function new()
	{
	}

	public function start():Void
	{
		///startMessenger();
		Remote.instance.loadMap(onMapLoaded);
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
	}
}
