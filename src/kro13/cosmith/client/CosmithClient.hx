package kro13.cosmith.client;

import kro13.cosmith.client.board.Board;
import kro13.cosmith.client.board.Updater;
import kro13.cosmith.client.board.data.GameData;
import kro13.cosmith.client.board.data.types.TGameObject;
import kro13.cosmith.client.ui.MainUI;

class CosmithClient
{
	public function new()
	{
	}

	public function start():Void
	{
		initData();
		startBoard();
		startUI();
		Updater.instance.start();
	}

	private function initData():Void
	{
		GameData.instance.init();
		var pawn:TGameObject = GameData.instance.go.newGameObject(PAWN);
		pawn.x = 10;
		pawn.y = 10;
		GameData.instance.map.addObject(pawn);
		GameData.instance.map.printObjects();
	}

	private function startBoard():Void
	{
		new Board().start();
	}

	private function startUI():Void
	{
		new MainUI().start();
	}
}
