package kro13.cosmith.client.board;

import kro13.cosmith.client.board.gameObjects.GameObject;
import kro13.cosmith.client.board.utils.IMapDrag;
import kro13.cosmith.client.board.utils.IMapZoom;
import kro13.cosmith.client.board.utils.MapGrid;
import kro13.cosmith.client.board.utils.MathUtils;
import kro13.cosmith.client.board.utils.SimpleMapDrag;
import kro13.cosmith.client.board.utils.SimpleMapZoom;
import kro13.cosmith.client.board.utils.TouchMapDrag;
import kro13.cosmith.client.board.utils.TouchMapZoom;
import kro13.cosmith.data.GameData;
import kro13.cosmith.data.scopes.GameObjectData;
import kro13.cosmith.data.scopes.MapData;
import kro13.cosmith.data.types.TGameMap;
import kro13.cosmith.data.types.TGameObject;
import kro13.cosmith.data.types.components.TRenderComponent;
import kro13.cosmith.data.types.components.TRevealedComponent;
import kro13.cosmith.data.types.components.TStatsComponent;
import openfl.events.MouseEvent;
import openfl.ui.Multitouch;

class GameMap extends GameSprite
{
	public var myHero(default, set):GameObjectData;

	private var grid:MapGrid;
	private var idsToInstances:Map<Int, GameObject>;
	private var idsToInstancesKeys:Array<Int>;
	private var selectedObj:GameObject;
	private var drag:IMapDrag;
	private var zoom:IMapZoom;
	private var data:TGameMap;

	public function new(data:TGameMap)
	{
		this.data = data;
		super(data.render);
		grid = new MapGrid();
		idsToInstances = new Map();
		idsToInstancesKeys = [];
	}

	private function set_myHero(val:GameObjectData):GameObjectData
	{
		myHero = val;
		var instance:GameObject = addInstance(myHero);
		var render:TRenderComponent = myHero.getComponent(RENDER);
		instance.handleInteraction(MOVE(render.x, render.y));
		return myHero;
	}

	override public function start():Void
	{
		super.start();
		addChild(grid);
		if (Multitouch.supportsTouchEvents)
		{
			zoom = new TouchMapZoom(this);
			drag = new TouchMapDrag(this);
		} else
		{
			drag = new SimpleMapDrag(this);
			zoom = new SimpleMapZoom(this);
		}
		drag.start();
		zoom.start();
		addEventListener(MouseEvent.CLICK, onClick);
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);
		if (myHero == null)
		{
			return;
		}

		var myRevealed:TRevealedComponent = myHero.getComponent(REVEALED);
		var myStats:TStatsComponent = myHero.getComponent(STATS);
		var myRender:TRenderComponent = myHero.getComponent(RENDER);

		// add new instances
		for (obj in GameData.instance.map.objects)
		{
			if (!hasInstance(obj))
			{
				if (myRevealed.ids.indexOf(obj.id) >= 0)
				{
					addInstance(obj);
					continue;
				}
				if (obj.type == HERO)
				{
					var objRender:TRenderComponent = obj.getComponent(RENDER);
					if (MathUtils.distanceInt(myRender.x, myRender.y, objRender.x, objRender.y) <= myStats.visionRange)
					{
						addInstance(obj);
					}
				}
			}
		}
		// remove redundant instances
		for (id in idsToInstancesKeys)
		{
			if (!GameData.instance.map.objectExists(id))
			{
				removeInstance(id);
				continue;
			}
			var instance:GameObject = idsToInstances.get(id);
			if (instance.data.type == HERO)
			{
				var objRender:TRenderComponent = instance.data.getComponent(RENDER);
				if (MathUtils.distanceInt(myRender.x, myRender.y, objRender.x, objRender.y) > myStats.visionRange)
				{
					removeInstance(id);
				}
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

	private function addInstance(obj:TGameObject):GameObject
	{
		var instance:GameObject = GameObjectsFactory.instance.buildGameObject(obj);
		instance.start();
		idsToInstancesKeys.push(obj.id);
		idsToInstances.set(obj.id, instance);
		addChild(instance);
		return instance;
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
		if (drag.isDragging || zoom.isZooming)
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

		if (myHero != null && selectedObj.data.id == myHero.id)
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
