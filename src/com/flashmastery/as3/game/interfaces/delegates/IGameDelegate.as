package com.flashmastery.as3.game.interfaces.delegates {

	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IGameDelegate {
		
		function reactOnStart( delegater : IInteractiveGameObject ) : void;
		function reactOnStop( delegater : IInteractiveGameObject ) : void;
		function reactOnDisposal( delegater : IInteractiveGameObject ) : void;
		function reactOnAddedToDelegater( delegater : IInteractiveGameObject ) : void;
		function reactOnRemovalFromDelegater( delegater : IInteractiveGameObject  ) : void;
		function reactOnGameFinished( result : Object, gameCore : IGameCore ) : void;
		
		function get gameCore() : IGameCore;
		function set gameCore( gameCore : IGameCore ) : void;
	}
}
