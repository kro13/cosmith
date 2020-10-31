package kro13.cosmith.data.types;

typedef TMessage =
{
	@:optional var userId:String;
	var text:String;
	var type:EMessageType;
}

enum EMessageType
{
	USER;
	COMMAND(command:ECommand);
}
