package kro13.cosmith.client;

import haxe.Json;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.GameDataFactory;
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

	private static inline var SERVER_URL:String = "http://127.0.0.1:8080";

	private var loadMapUrl:String = '${SERVER_URL}/loadMap';
	private var spawnHeroUrl:String = '${SERVER_URL}/spawnHero';

	private function new()
	{
	}

	public function loadMap(onSuccess:TGameMap->Void = null, onError:Dynamic->Void = null)
	{
		get(loadMapUrl, onSuccess, onError);
	}

	public function spawnHero(onSuccess:Dynamic->Void = null, onError:Dynamic->Void = null)
	{
		var hero = {name: "Brave Hero"};
		post(spawnHeroUrl, hero, onSuccess, onError);
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
					onSuccess(Json.parse(data.body));
				}

			case Failure(failure):
				if (onError != null)
				{
					onError(failure);
				}
		}
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
