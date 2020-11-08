package kro13.cosmith.client.ui.messenger;

import js.Browser.document;
import js.html.DivElement;
import js.html.Event;
import js.html.TextAreaElement;
import kro13.cosmith.client.messenger.Messenger;
import kro13.cosmith.data.types.TMessage;
import react.ReactComponent.ReactComponentOfPropsAndState;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class MessengerUI extends ReactComponentOfPropsAndState<MessengerUIProps, MessengerUIState>
{
	private static var messageKeys:Int = 0;

	private static var defaultProps:MessengerUIProps =
		{
			btnSendText: "Send",
			inputPlaceholder: "Type something..."
		};

	private var chatbox:DivElement;

	public function new(props:MessengerUIProps)
	{
		super(props);
		Messenger.instance.onReceive.add(onMessageReceive);
		state =
			{
				allMessages: [],
				inputMessage: ""
			};
	}

	override public function render():ReactElement
	{
		var msgItems:Array<Dynamic> = state.allMessages.map(msg ->
			jsx('<$MessageUI key={messageKeys++} isMine={Messenger.instance.isMine(msg.userId)} text={msg.text}/>'));

		return jsx('
		<div className="py-3 pl-3 h-100 w-100 bg-dark d-flex flex-column"><!--flex-column to resize content properly-->
			<div id="chatbox" className="mb-3 pb-3 overflow-auto h-100 w-100 flex-column bg-white rounded">
				{msgItems}
			</div>
			<div className="input-group">
				<textarea placeholder={props.inputPlaceholder} value={state.inputMessage} onChange=$onInput className="form-control" style={{resize: "none"}}></textarea>
				<div className="input-group-append">
					<button type="button" onClick=$onSendClick className="btn btn-primary">{props.btnSendText}</button>
				</div>
			</div>
		</div>
		');
	}

	override public function componentDidMount()
	{
		chatbox = cast document.getElementById("chatbox");
	}

	override public function componentDidUpdate(prevProps:MessengerUIProps, prevState:MessengerUIState):Void
	{
		chatbox.scrollTop = chatbox.scrollHeight;
	}

	private function onInput(e:Event):Void
	{
		setState({inputMessage: cast(e.target, TextAreaElement).value});
	}

	private function onMessageReceive(message:TMessage)
	{
		state.allMessages.push(message);
		setState({allMessages: state.allMessages});
	}

	private function onSendClick(e:Event):Void
	{
		if (state.inputMessage.length != 0)
		{
			Messenger.instance.sendUser(state.inputMessage);
			setState({inputMessage: ""});
		}
	}
}

typedef MessengerUIProps =
{
	var btnSendText:String;
	var inputPlaceholder:String;
}

typedef MessengerUIState =
{
	var inputMessage:String;
	var allMessages:Array<TMessage>;
}
