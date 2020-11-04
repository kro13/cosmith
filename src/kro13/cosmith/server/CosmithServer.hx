package kro13.cosmith.server;

import haxe.Json;
import js.Node;
import js.node.http.Server as NodeServer;
import js.node.socketio.Server as SocketServer;
import js.node.socketio.Server;
import js.node.socketio.Socket;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.GameDataFactory;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.TMessage;
import kro13.cosmith.server.middleware.CORS;
import kro13.cosmith.server.middleware.Log;
import tink.CoreApi.Future;
import tink.http.Handler;
import tink.http.Response.OutgoingResponse;
import tink.http.containers.NodeContainer;
import tink.web.routing.*;

class CosmithServer
{
	public static function main()
	{
		var port:Int = 8080;
		#if !local_server
		port = Std.parseInt(Node.process.env.get("PORT"));
		#end

		initData();

		trace("Init server...");
		var nodeServer:NodeServer = new NodeServer();
		var socketServer:SocketServer = new SocketServer();
		initRouter(nodeServer, socketServer);
		initMessenger(socketServer, nodeServer);
		start(nodeServer, socketServer, port);
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

	private static function initMessenger(socketServer:SocketServer, nodeServer:NodeServer):Void
	{
		socketServer.on("connection", (socket:Socket) ->
		{
			trace('User ${socket.id} connected');
			socketServer.sockets.to(socket.id).emit("_id", socket.id);
			socket.on("message", (message:TMessage) ->
			{
				socketServer.sockets.emit("message", message);
			});
		});
	}

	private static function initRouter(nodeServer:NodeServer, socketServer:SocketServer):Void
	{
		var container:NodeContainer = new NodeContainer(nodeServer);
		var router = new Router<Root>(new Root(socketServer));
		var handler:Handler = (req) ->
		{
			return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
		};
		container.run(applyMiddleware(handler));
	}

	private static function applyMiddleware(handler:Handler):Handler
	{
		var log:Log = new Log();
		var cors:CORS = new CORS(
			{
				allowOrigin: ["http://127.0.0.1:3000", "https://v6p9d9t4.ssl.hwcdn.net"]
			});
		// handler = log.apply(handler);
		handler = cors.apply(handler);
		return handler;
	}

	private static function start(nodeServer:NodeServer, socketServer:SocketServer, port:Int):Void
	{
		nodeServer.listen(port);
		socketServer.listen(nodeServer);
		trace('Server started at ${port}');
	}
}

class Root
{
	var socketServer:SocketServer;

	public function new(socketServer:SocketServer)
	{
		this.socketServer = socketServer;
	}

	@:get('/')
	public function root()
	{
		return Future.sync(('COSMITH' : OutgoingResponse));
	}

	// @:header("Access-Control-Allow-Origin", "*")

	@:get('/loadMap')
	public function loadMap():TGameMap
	{
		trace("Load map");
		return GameData.instance.map.data;
	}

	// @:header("Access-Control-Allow-Origin", "*")

	@:post('/spawnHero')
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
