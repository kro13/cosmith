package kro13.cosmith.client.board;

import kro13.cosmith.client.board.gameObjects.GameObject;
import kro13.cosmith.client.board.utils.MapGrid;
import kro13.cosmith.client.board.utils.SimpleMapDrag;
import kro13.cosmith.client.board.utils.SimpleMapZoom;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.TGameObject;
import openfl.events.MouseEvent;

class GameMap extends GameObject
{
	private var grid:MapGrid;
	private var idsToInstances:Map<Int, GameObject>;
	private var idsToInstancesKeys:Array<Int>;
	private var selectedObj:GameObject;
	private var drag:SimpleMapDrag;
	private var zoom:SimpleMapZoom;

	public function new(data:TGameObject)
	{
		super(data);
		grid = new MapGrid();
		idsToInstances = new Map();
		idsToInstancesKeys = [];
	}

	override public function start()
	{
		super.start();
		addChild(grid);
		drag = new SimpleMapDrag(this);
		zoom = new SimpleMapZoom(this);
		drag.start();
		zoom.start();
		addEventListener(MouseEvent.CLICK, onClick);
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);
		// add new instances
		for (obj in GameData.instance.map.objects)
		{
			if (!hasInstance(obj))
			{
				trace(obj.id);
				var goInstance:GameObject = GameObjectsFactory.instance.buildGameObject(obj);
				goInstance.start();
				addInstance(obj.id, goInstance);
			}
		}
		// remove redundant instances
		for (id in idsToInstancesKeys)
		{
			if (!GameData.instance.map.objectExists(id))
			{
				removeInstance(id);
			}
		}
	}

	override private function positionTiles(x:Int, y:Int):Void
	{
		// controlled by map drag
	}

	override private function resize(w:Int, h:Int):Void
	{
		super.resize(w, h);
		grid.redraw(w, h);
	}

	private function addInstance(id:Int, instance:GameObject):Void
	{
		idsToInstancesKeys.push(id);
		idsToInstances.set(id, instance);
		addChild(instance);
	}

	private function removeInstance(id:Int):Void
	{
		var instance:GameObject = idsToInstances.get(id);
		if (selectedObj == instance)
		{
			selectedObj = null;
		}
		removeChild(instance);
		idsToInstances.remove(id);
		idsToInstancesKeys.remove(id);
	}

	private function hasInstance(go:TGameObject):Bool
	{
		return idsToInstances.exists(go.id);
	}

	private function onClick(e:MouseEvent):Void
	{
		trace(drag.isDragging);
		if (drag.isDragging)
		{
			return;
		}

		var clickedObj:GameObject = cast e.target;

		if (clickedObj == null)
		{
			return;
		}

		if (selectedObj == null)
		{
			if (clickedObj.selectable)
			{
				selectObject(clickedObj);
			}
			return;
		}

		if (selectedObj == clickedObj)
		{
			unselectObject(clickedObj);
			return;
		}

		if (selectedObj.movable)
		{
			moveSelectedObject(mouseXToTiles(e.stageX), mouseYToTiles(e.stageY));
			return;
		}

		doNothingSelectedObject();
	}

	private function selectObject(go:GameObject):Void
	{
		selectedObj = go;
		selectedObj.handleInteraction(SELECT);
	}

	private function unselectObject(go:GameObject):Void
	{
		selectedObj.handleInteraction(UNSELECT);
		selectedObj = null;
	}

	private function moveSelectedObject(tilesX:Int, tilesY:Int):Void
	{
		selectedObj.data.x = tilesX;
		selectedObj.data.y = tilesY;
		selectedObj.handleInteraction(MOVE(tilesX, tilesY));
	}

	private function doNothingSelectedObject():Void
	{
		selectedObj.handleInteraction(NONE);
	}

	private function mouseXToTiles(mouseX:Float):Int
	{
		return Math.ceil(((mouseX) / (scaleX * parent.scaleX) - x / scaleX) / MapData.TILE_SIZE);
	}

	private function mouseYToTiles(mouseY:Float):Int
	{
		return Math.ceil(((mouseY) / (scaleY * parent.scaleY) - y / scaleY) / MapData.TILE_SIZE);
	}
}