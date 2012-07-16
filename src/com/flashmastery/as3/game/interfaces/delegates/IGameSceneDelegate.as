package com.flashmastery.as3.game.interfaces.delegates {

	import com.flashmastery.as3.game.interfaces.core.IGameDirector;
	import com.flashmastery.as3.game.interfaces.core.IGameScene;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IGameSceneDelegate extends IGameDelegate {
		
		function reactOnSceneAdded( director : IGameDirector, scene : IGameScene ) : void;
		function reactOnSceneRemoval( scene : IGameScene ) : void;
		function reactOnSceneUpdate( deltaTime : Number, scene : IGameScene ) : void;
		
	}
}
