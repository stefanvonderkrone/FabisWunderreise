package com.flashmastery.as3.game.interfaces.core {

	import flash.geom.Rectangle;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IGraphicsCore extends IInteractiveGameObject, IGameAnimatable {
		
		function addScene( scene : IGameScene ) : IGameScene;
		function addSceneAt( scene : IGameScene, index : uint ) : IGameScene;
		function contains( scene : IGameScene ) : Boolean;
		function getSceneAt( index : uint ) : IGameScene;
		function getSceneByName( name : String ) : IGameScene;
		function getSceneIndex( scene : IGameScene ) : int;
		function removeScene( scene : IGameScene, dispose : Boolean = false ) : IGameScene;
		function removeSceneAt( index : uint, dispose : Boolean = false ) : IGameScene;
		function removeScenes( beginIndex : uint = 0, endIndex : int = -1, dispose : Boolean = false ) : void;
		function setSceneIndex( scene : IGameScene, index : uint ) : void;
		function setupWithStage( stage : DisplayObjectContainer ) : void;
		function swapScenes( scene1 : IGameScene, scene2 : IGameScene ) : void;
		function swapScenesAt( index1 : uint, index2 : uint ) : void;
		function setPosition( x : Number, y: Number ) : void;
		function setSize( width : Number, height : Number ) : void;
		
		function get stage() : DisplayObjectContainer;
		function get graphicsStage() : Object;
		function get graphicsEngine() : Object;
		function get viewPort() : Rectangle;
	}
}
