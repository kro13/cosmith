package kro13.cosmith.client.ui;

import haxe.Json;
import js.Browser.document;
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import js.html.Event;
import js.html.LinkElement;
import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.client.ui.messenger.MessengerUI;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.types.TMessage;
import openfl.Lib;
import react.ReactComponent.ReactComponentOfPropsAndState;
import react.ReactComponent.ReactElement;
import react.ReactDOM;
import react.ReactMacro.jsx;

class MainUI extends ReactComponentOfPropsAndState<MainUIProps, MainUIState>
{
	private static inline var MESSENGER_UI_WIDTH_PERCENT:Int = 50;

	private static var defaultProps:MainUIProps =
		{
			btnHideText: ">",
			btnShowText: "<",
			btnSpawnText: "+"
		};

	private var canvas:CanvasElement;
	private var uiRoot:DivElement;
	private var contentRoot:DivElement;

	public function new()
	{
		super(props);
		state =
			{
				messengerVisible: true,
				spawnVisible: true
			};
	}

	public function start():Void
	{
		uiRoot = cast document.getElementById("uiRoot");
		contentRoot = cast document.getElementById("contentRoot");
		canvas = cast document.getElementsByTagName("canvas").item(0);
		ReactDOM.render(jsx('<$MainUI/>'), uiRoot);
		Lib.current.addEventListener(openfl.events.Event.ENTER_FRAME, onEnterFrame);
	}

	override public function componentWillUnmount():Void
	{
		trace("will unmount");
		Messenger.instance.onReceive.remove(onMessageReceive);
	}

	override public function componentDidMount()
	{
		trace("did mount");
	}

	override public function render()
	{
		contentRoot = cast document.getElementById("contentRoot");
		uiRoot = cast document.getElementById("uiRoot");
		if (state.messengerVisible)
		{
			contentRoot.style.width = '${100 - MESSENGER_UI_WIDTH_PERCENT}%';
			uiRoot.style.width = '${MESSENGER_UI_WIDTH_PERCENT}%';
		} else
		{
			contentRoot.style.width = "100%";
			uiRoot.style.width = null;
		}

		return jsx('
		<div className="h-100 w-100 d-flex justify-content-end">
			<div className="h-100 w-100" style={{display:state.messengerVisible ? "block" : "none"}}>
				<$MessengerUI/>
			</div>
			<div className="h-100 bg-dark p-3">
				<div>
					<button type="button" onClick=$onBtnShowHideClick className="btn btn-primary">
						{state.messengerVisible ? props.btnHideText : props.btnShowText}
					</button>
				</div>
				<div style={{display:state.spawnVisible ? "block" : "none"}}>
					<button type="button" onClick=$onBtnSpawnClick className="btn btn-primary mt-3">
						{props.btnSpawnText}
					</button>
				</div>
			</div>
		</div>	
		');
	}

	private function onBtnShowHideClick(e:Event):Void
	{
		setState({messengerVisible: !state.messengerVisible});
	}

	private function onBtnSpawnClick(e:Event):Void
	{
		Messenger.instance.onReceive.add(onMessageReceive);
		Remote.instance.spawnHero();
	}

	private function onMessageReceive(message:TMessage):Void
	{
		if (GameData.instance.map.getHeroByUserId(Messenger.instance.userId) == null)
		{
			setState({spawnVisible: false});
			Messenger.instance.onReceive.remove(onMessageReceive);
		}
	}

	private function onEnterFrame(e:openfl.events.Event):Void
	{
		canvas.width = contentRoot.clientWidth;
		canvas.style.width = '${canvas.width}px';
	}

	// not used
	private function addCSS()
	{
		var link:LinkElement = document.createLinkElement();
		link.rel = "stylesheet";
		link.href = "css/main.css";
		link.type = "text/css";
		document.body.appendChild(link);
	}
}

typedef MainUIProps =
{
	var btnShowText:String;
	var btnHideText:String;
	var btnSpawnText:String;
}

typedef MainUIState =
{
	var messengerVisible:Bool;
	var spawnVisible:Bool;
}
