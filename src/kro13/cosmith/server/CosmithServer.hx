package kro13.cosmith.server;

import haxe.Json;
import js.Node;
import js.node.http.Server as NodeServer;
import js.node.socketio.Server as SocketServer;
import js.node.socketio.Server;
import js.node.socketio.Socket;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.GameDataFactory;
import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.types.ECommand;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.TMessage;
import kro13.cosmith.data.types.components.TOwnerComponent;
import kro13.cosmith.data.types.components.TRenderComponent;
import kro13.cosmith.server.middleware.CORS;
import kro13.cosmith.server.middleware.Log;
import tink.CoreApi.Future;
import tink.Stringly;
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
		var npc1:GameObjectData = factory.newGameObject(Storage.goIds++, NPC);
		npc1.setPosition(20, 10);
		GameData.instance.map.addObject(npc1);
		var npc2:GameObjectData = factory.newGameObject(Storage.goIds++, NPC);
		npc2.setPosition(10, 20);
		GameData.instance.map.addObject(npc2);
		// GameData.instance.map.printObjects();
	}

	private static function initMessenger(socketServer:SocketServer, nodeServer:NodeServer):Void
	{
		socketServer.on("connection", (socket:Socket) ->
		{
			trace('User ${socket.id} connected');
			socketServer.sockets.to(socket.id).emit("_id", socket.id);
			socket.on("message", (message:TMessage) ->
			{
				processMessage(message);
				socketServer.sockets.emit("message", message);
			});
		});
	}

	private static function processMessage(message:TMessage):Void
	{
		switch (message.type)
		{
			case COMMAND(command):
				GameData.instance.process(command);
			default:
		}
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
				allowOrigin: []
				// allowOrigin: ["http://127.0.0.1:3000", "https://v6p9d9t4.ssl.hwcdn.net"]
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
	public function loadMap():String
	{
		return Json.stringify(GameData.instance.map.data);
	}

	// @:header("Access-Control-Allow-Origin", "*")

	@:post('/spawnHero')
	public function spawnHero(body:{userId:String, name:String}):String
	{
		if (GameData.instance.map.getHeroByUserId(body.userId) == null)
		{
			var hero:GameObjectData = GameDataFactory.instance.newGameObject(Storage.goIds++, HERO);
			var owner:TOwnerComponent = hero.getComponent(OWNER);
			owner.userId = body.userId;
			var render:TRenderComponent = hero.getComponent(RENDER);
			hero.setPosition(Math.round(Math.random() * 30), Math.round(Math.random() * 30));
			hero.name = body.name;
			var spawnCmd:ECommand = SPAWN(hero);
			GameData.instance.process(spawnCmd);
			socketServer.sockets.emit("message",
				{
					text: 'Spawn hero ${hero.name} at (${render.x} ${render.y})',
					type: COMMAND(spawnCmd)
				});
		}
		return Json.stringify({status: "OK"});
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
