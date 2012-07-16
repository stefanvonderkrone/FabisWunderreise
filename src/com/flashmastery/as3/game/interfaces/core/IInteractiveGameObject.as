package com.flashmastery.as3.game.interfaces.core {
	import com.flashmastery.as3.game.interfaces.delegates.IGameDelegate;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IInteractiveGameObject extends IRecycable {
		
		function start() : void;
		function stop() : void;
		
		function get gameCore() : IGameCore;
		function set gameCore( gameCore : IGameCore ) : void;
		
		function get delegate() : IGameDelegate;
		function set delegate( delegate : IGameDelegate ) : void;
		
		function get isRunning() : Boolean;
	}
}
