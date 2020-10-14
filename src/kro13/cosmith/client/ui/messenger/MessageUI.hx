package kro13.cosmith.client.ui.messenger;

import react.ReactComponent.ReactComponentOfProps;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class MessageUI extends ReactComponentOfProps<MessageUIProps>
{
	private static var defaultProps:MessageUIProps =
		{
			key: 0,
			isMine: true,
			text: "Who's there?"
		}

	public function new(props:MessageUIProps)
	{
		super(props);
	}

	override public function render():ReactElement
	{
		if (props.isMine)
		{
			return renderMine();
		}
		return renderNotMine();
	}

	private function renderMine():ReactElement
	{
		return jsx('
		<div className="pt-3 px-3 d-flex justify-content-end">
			<div className="p-3 d-inline-flex bg-secondary rounded text-white text text-justify text-left text-break">
				{props.text}
			</div>	
		</div>
		');
	}

	private function renderNotMine():ReactElement
	{
		return jsx('
		<div className="pt-3 px-3 d-flex">
			<div className="p-3 d-inline-flex bg-light rounded text-sectondary text text-justify text-left text-break">
				{props.text}
			</div>	
		</div>
		');
	}
}

typedef MessageUIProps =
{
	var key:Int;
	var isMine:Bool;
	var text:String;
}
