package kro13.cosmith.server;

import kro13.cosmith.types.TMessage;
import js.node.socketio.Socket;
import js.node.socketio.Server;

class CosmithServer
{
	public static function main()
	{
		trace("server started");
		var server:Server = new Server();
		server.listen(8070);
		server.on("connection", (socket:Socket) ->
		{
			trace('user ${socket.id} connected');
			server.sockets.to(socket.id).emit("_id", socket.id);
			socket.on("message", (message:TMessage) ->
			{
				server.sockets.emit("message", message);
			});
		});
	}
}
