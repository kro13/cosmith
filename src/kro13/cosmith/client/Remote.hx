package kro13.cosmith.client;

import haxe.Json;
import kro13.cosmith.data.types.TGameMap;
import tink.core.Error;
import tink.core.Outcome;
import tink.http.Client;
import tink.http.Fetch.FetchOptions;
import tink.http.Method;
import tink.io.Source.IdealSource;

class Remote
{
	public static var instance(get, null):Remote;

	#if local_server
	public static inline var SERVER_URL:String = "http://127.0.0.1:8080";
	#else
	public static inline var SERVER_URL:String = "https://cosmith-server.herokuapp.com";
	#end

	private var loadMapUrl:String = '${SERVER_URL}/loadMap';
	private var spawnHeroUrl:String = '${SERVER_URL}/spawnHero';

	private function new()
	{
		trace('Remote ${SERVER_URL}');
	}

	public function loadMap(onSuccess:TGameMap->Void = null, onError:Dynamic->Void = null)
	{
		get(loadMapUrl, onSuccess, onError != null ? onError : onRemoteError);
	}

	public function spawnHero(onSuccess:Dynamic->Void = null, onError:Dynamic->Void = null)
	{
		var hero = {name: "Brave Hero"};
		post(spawnHeroUrl, hero, onSuccess, onError != null ? onError : onRemoteError);
	}

	private function get(url:String, onSuccess:Dynamic->Void, onError:Dynamic->Void):Void
	{
		var options:FetchOptions =
			{
				method: Method.GET
			}
		Client.fetch(url).all().handle((o) -> processOutcome(o, onSuccess, onError));
	}

	private function post(url:String, data:Any, onSuccess:Dynamic->Void, onError:Dynamic->Void):Void
	{
		var body:IdealSource = Json.stringify(data);
		var options:FetchOptions =
			{
				method: Method.POST,
				body: body,
			}
		Client.fetch(url, options).all().handle((o) -> processOutcome(o, onSuccess, onError));
	}

	private function processOutcome(o:Outcome<Dynamic, Error>, onSuccess:Dynamic->Void, onError:Dynamic->Void)
	{
		switch o
		{
			case Success(data):
				if (onSuccess != null)
				{
					var body:Dynamic = null;
					try
					{
						body = Json.parse(data.body);
						onSuccess(body);
					} catch (e)
					{
						onError(e);
					}
				}

			case Failure(failure):
				if (onError != null)
				{
					onError(failure);
				}
		}
	}

	private function onRemoteError(e:Dynamic):Void
	{
		trace('Remote error: ${e}');
	}

	private static function get_instance():Remote
	{
		if (instance == null)
		{
			instance = new Remote();
		}
		return instance;
	}
}
