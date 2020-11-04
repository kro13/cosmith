package kro13.cosmith.server.middleware;

import tink.http.Handler;

interface IMiddleware
{
	function apply(handler:Handler):Handler;
}
