package kro13.cosmith.server;

import haxe.Json;
import js.Node;
import js.node.socketio.Server;
import js.node.socketio.Socket;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.GameDataFactory;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.TMessage;
import tink.CoreApi.Future;
import tink.http.Response.OutgoingResponse;
import tink.http.containers.NodeContainer;
import tink.web.routing.*;

class CosmithServer
{
	private static var socketServer:Server;

	public static function main()
	{
		initData();
		// startMessenger();
		startRouter();
	}

	private static function initData()
	{
		var factory:GameDataFactory = GameDataFactory.instance;
		GameData.instance.init(factory.newMap(100, 100));
		// some mock data
		var npc1:TGameObject = factory.newGameObject(Storage.goIds++, NPC);
		npc1.x = 20;
		npc1.y = 10;
		GameData.instance.map.addObject(npc1);
		var npc2:TGameObject = factory.newGameObject(Storage.goIds++, NPC);
		npc2.x = 10;
		npc2.y = 20;
		GameData.instance.map.addObject(npc2);
	}

	private static function startMessenger():Void
	{
		socketServer = new Server();
		socketServer.listen(8070);
		socketServer.on("connection", (socket:Socket) ->
		{
			trace('user ${socket.id} connected');
			socketServer.sockets.to(socket.id).emit("_id", socket.id);
			socket.on("message", (message:TMessage) ->
			{
				socketServer.sockets.emit("message", message);
			});
		});
		trace("Messenger started");
	}

	private static function startRouter():Void
	{
		trace('Start router at port ${Node.process.env.get("$PORT")}');
		var container:NodeContainer = new NodeContainer(Node.process.env.get("$PORT"));
		var router = new Router<Root>(new Root(socketServer));
		container.run((req) ->
		{
			return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
		});
		trace("Router started");
	}
}

class Root
{
	private var socketServer:Server;

	public function new(socketServer:Server)
	{
		this.socketServer = socketServer;
	}

	@:get('/')
	public function root()
	{
		return Future.sync(('COSMITH' : OutgoingResponse));
	}

	@:get('/loadMap')
	@:header("Access-Control-Allow-Origin", "http://127.0.0.1:3000")
	public function map():TGameMap
	{
		trace("Load map");
		return GameData.instance.map.data;
	}

	@:post('/spawnHero')
	@:header("Access-Control-Allow-Origin", "http://127.0.0.1:3000")
	public function spawnHero(body:{name:String}):TStatus
	{
		trace('Spawn hero ${body.name}');
		var hero:TGameObject = GameDataFactory.instance.newGameObject(Storage.goIds++, HERO);
		hero.name = body.name;
		hero.x = Math.round(Math.random() * 30);
		hero.y = Math.round(Math.random() * 30);
		GameData.instance.map.addObject(hero);
		socketServer.sockets.emit("message",
			{
				text: 'Spawn hero ${hero.name} at (${hero.x} ${hero.y})',
				type: COMMAND(SPAWN(hero.id, hero.type, hero.x, hero.y, hero.name))
			});
		return {status: "OK"};
	}
}

typedef TStatus =
{
	var status:String;
}

class Storage
{
	public static var goIds:Int = 0;
}
