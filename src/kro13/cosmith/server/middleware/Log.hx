package kro13.cosmith.server.middleware;

import tink.core.Future;
import tink.http.Handler;
import tink.http.Request.IncomingRequest;
import tink.http.Response.OutgoingResponse;

class Log implements IMiddleware
{
	public function new()
	{
	}

	public function apply(handler:Handler):Handler
	{
		return (req:IncomingRequest) ->
		{
			trace(req.body);
			trace(req.header);
			return handler.process(req);
		};
	}
}
