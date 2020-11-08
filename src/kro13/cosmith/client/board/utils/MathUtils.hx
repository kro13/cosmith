package kro13.cosmith.client.board.utils;

class MathUtils
{
	public static function distanceInt(x1:Int, y1:Int, x2:Int, y2:Int):Int
	{
		return Math.floor(Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)));
	}
}
