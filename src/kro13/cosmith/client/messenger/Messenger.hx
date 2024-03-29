package kro13.cosmith.client.messenger;

import js.node.socketio.Client;
import kro13.cosmith.data.types.ECommand;
import kro13.cosmith.data.types.TMessage;
import msignal.Signal.Signal1;

class Messenger
{
	public static var instance(get, null):Messenger;

	public var onReceive:Signal1<TMessage>;
	public var userId(default, null):String = "no_id";

	private var client:Client;

	private function new(offline:Bool = false)
	{
		onReceive = new Signal1();
	}

	public function start()
	{
		client = new Client(Remote.SERVER_URL);
		client.on("_id", onId);
		client.on("message", onMessage);
	}

	public function sendUser(text:String):Void
	{
		send({userId: userId, type: USER, text: text});
	}

	public function sendCommand(text:String, command:ECommand = NONE):Void
	{
		send({type: COMMAND(command), text: text});
	}

	public function send(message:TMessage):Void
	{
		if (client == null) // socket turned off
		{
			onMessage(message);
			return;
		}
		client.emit("message", message);
	}

	public function isMine(id:String):Bool
	{
		return id != null && id == userId;
	}

	private function onId(id:String):Void
	{
		userId = id;
		trace('got id ${userId}');
	}

	private function onMessage(message:TMessage):Void
	{
		onReceive.dispatch(message);
	}

	private static function get_instance():Messenger
	{
		if (instance == null)
		{
			instance = new Messenger();
		}
		return instance;
	}
}
