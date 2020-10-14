package kro13.cosmith.client.messenger;

import js.node.socketio.Client;
import kro13.cosmith.types.TMessage;
import msignal.Signal.Signal1;

class Messenger
{
	public static inline var ID_NONE:String = "id_none";

	public static var instance(get, null):Messenger;

	public var onReceive:Signal1<TMessage>;

	private var client:Client;
	private var userId(default, null):String;

	private function new()
	{
		onReceive = new Signal1();
	}

	public function start()
	{
		client = new Client("http://localhost:8070/");
		client.on("_id", onId);
		client.on("message", onMessage);
	}

	public function send(message:TMessage):Void
	{
		if (message.userId == null)
		{
			message.userId = userId;
		}
		if (client == null) // socket turned off
		{
			onMessage(message);
			return;
		}
		client.emit("message", message);
	}

	public function isMine(message:TMessage):Bool
	{
		return message.userId == userId;
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
