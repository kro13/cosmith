package kro13.cosmith.client.ui;

import haxe.Json;
import js.Browser.document;
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import js.html.Event;
import js.html.LinkElement;
import kro13.cosmith.client.ui.messenger.MessengerUI;
import openfl.Lib;
import react.ReactComponent.ReactComponentOfPropsAndState;
import react.ReactComponent.ReactElement;
import react.ReactDOM;
import react.ReactMacro.jsx;

class MainUI extends ReactComponentOfPropsAndState<MainUIProps, MainUIState>
{
	private static var defaultProps:MainUIProps =
		{
			btnHideText: ">",
			btnShowText: "<"
		};

	private var canvas:CanvasElement;
	private var uiRoot:DivElement;
	private var contentRoot:DivElement;

	public function new()
	{
		super(props);
		state =
			{
				messengerVisible: true
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

	override public function render()
	{
		contentRoot = cast document.getElementById("contentRoot");
		uiRoot = cast document.getElementById("uiRoot");
		if (state.messengerVisible)
		{
			contentRoot.style.width = "50%";
			uiRoot.style.width = "50%";
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
			<div className="h-100 bg-dark p-3" style={{pointerEvents:"all"}}>
				<button type="button" onClick=$onBtnShowHideClick className="btn btn-primary caret-right-fill">
				{state.messengerVisible ? props.btnHideText : props.btnShowText}
				</button>
			</div>
		</div>	
		');
	}

	private function onBtnShowHideClick(e:Event):Void
	{
		setState({messengerVisible: !state.messengerVisible});
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
}

typedef MainUIState =
{
	var messengerVisible:Bool;
}
