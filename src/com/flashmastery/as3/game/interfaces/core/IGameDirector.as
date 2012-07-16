package com.flashmastery.as3.game.interfaces.core {

	import com.flashmastery.as3.collections.interfaces.IImmutableList;
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IGameDirector extends IInteractiveGameObject {
		
		function setupWithGraphicsCore( graphicsCore : IGraphicsCore ) : void;
		
		function clear( disposeScenes : Boolean = true ) : void;
		function runWithScene( scene : IGameScene, disposeExistingScenes : Boolean = true ) : void;
		function pushScene( scene : IGameScene ) : void;
		function popScene( disposeScene : Boolean = true ) : IGameScene;
		function replaceScene( scene : IGameScene, disposeScene : Boolean = true ) : void;
		function getSceneByName( name : String ) : IGameScene;
		function getAllScenes() : IImmutableList;
		function get currentScene() : IGameScene;
		
	}
}
