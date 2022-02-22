package kro13.cosmith.server.middleware;

import tink.http.Handler;
import tink.http.Header.HeaderField;
import tink.http.Request.IncomingRequest;
import tink.http.Response.OutgoingResponse;

class CORS implements IMiddleware
{
	var config:TCORSConfig;

	public function new(config:TCORSConfig)
	{
		this.config = config;
	}

	public function apply(handler:Handler):Handler
	{
		return (req:IncomingRequest) ->
		{
			var origin:String = req.header.get(ORIGIN)[0];
			var headers:Array<HeaderField> = [];
			if (config.allowOrigin.length > 0 && config.allowOrigin.indexOf(origin) >= 0)
			{
				headers.push(new HeaderField(ACCESS_CONTROL_ALLOW_ORIGIN, origin));
			} else
			{
				headers.push(new HeaderField(ACCESS_CONTROL_ALLOW_ORIGIN, "*"));
			}

			return handler.process(req).map((res) ->
			{
				return new OutgoingResponse(res.header.concat(headers), res.body);
			});
		};
	}
}

typedef TCORSConfig =
{
	allowOrigin:Array<String>
}
