package kro13.cosmith.client.board;

import kro13.cosmith.client.board.data.GameData;
import kro13.cosmith.client.board.data.scopes.MapData;
import kro13.cosmith.client.board.data.types.TGameObject;
import kro13.cosmith.client.board.gameObjects.GameObject;
import kro13.cosmith.client.board.utils.MapGrid;
import kro13.cosmith.client.board.utils.SimpleMapDrag;
import kro13.cosmith.client.board.utils.SimpleMapZoom;
import openfl.events.MouseEvent;

class GameMap extends GameObject
{
	private var grid:MapGrid;
	private var idsToInstances:Map<Int, GameObject>;
	private var idsToInstancesKeys:Array<Int>;
	private var selectedGO:GameObject;
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

	override public function positionTiles(x:Int, y:Int):Void
	{
		// controlled by map drag
	}

	override public function resize(w:Int, h:Int):Void
	{
		super.resize(w, h);
		grid.redraw(w, h);
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);
		// add new instances
		for (obj in GameData.instance.map.objects)
		{
			if (!hasInstance(obj))
			{
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

	private function addInstance(id:Int, instance:GameObject):Void
	{
		idsToInstancesKeys.push(id);
		idsToInstances.set(id, instance);
		addChild(instance);
	}

	private function removeInstance(id:Int):Void
	{
		var instance:GameObject = idsToInstances.get(id);
		if (selectedGO == instance)
		{
			selectedGO = null;
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
		var clickedObj:Dynamic = e.target;
		if (Std.is(clickedObj, GameObject) && clickedObj.isSelectable())
		{
			selectObject(clickedObj);
		} else if (selectedGO != null)
		{
			moveObject(e.localX, e.localY);
		}
	}

	private function selectObject(go:GameObject):Void
	{
		if (selectedGO == go)
		{
			selectedGO.handleInteraction(EGOInteraction.CLICK_OUTSIDE);
			selectedGO = null;
			return;
		}
		selectedGO = go;
		if (selectedGO != null)
		{
			selectedGO.handleInteraction(EGOInteraction.CLICK);
		}
	}

	private function moveObject(mouseX:Float, mouseY:Float):Void
	{
		var tilesX:Int = mouseXToTiles(mouseX);
		var tilesY:Int = mouseYToTiles(mouseY);
		selectedGO.data.x = tilesX;
		selectedGO.data.y = tilesY;
		selectedGO.handleInteraction(EGOInteraction.MOVE(tilesX, tilesY));
	}

	private function mouseXToTiles(x:Float):Int
	{
		return Math.ceil(x / MapData.TILE_SIZE);
	}

	private function mouseYToTiles(y:Float):Int
	{
		return return Math.ceil(y / MapData.TILE_SIZE);
	}
}
