package kro13.cosmith.client.board.data.types;

typedef TGameObject =
{
	var id:Int;
	var type:EGameObjectType;
	var image:String;
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
	var name:String;
}

enum EGameObjectType
{
	NONE;
	PAWN;
}
