package com.flashmastery.as3.game.interfaces.core {
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IGameJuggler extends IGameAnimatable, IRecycable {

		function addAnimatable( animatable : IGameAnimatable ) : IGameAnimatable;
		function hasAnimatable( animatable : IGameAnimatable ) : Boolean;
		function removeAnimatable( animatable : IGameAnimatable ) : IGameAnimatable;
		function removeAllAnimatables() : void;

		// in seconds
		function get elapsedTime() : Number;

		function get currentDeltaTime() : Number;

	}
}
