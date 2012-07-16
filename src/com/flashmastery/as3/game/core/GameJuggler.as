package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IGameAnimatable;
	import com.flashmastery.as3.game.interfaces.core.IGameJuggler;

	import flash.utils.getTimer;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class GameJuggler extends Object implements IGameJuggler {

		protected var _animatables : Vector.<IGameAnimatable>;
		protected var _elapsedTime : Number;
		protected var _deltaToGlobalTime : uint;
		protected var _created : Boolean;

		public function GameJuggler() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				_elapsedTime = 0;
				_deltaToGlobalTime = getTimer();
				_animatables = new Vector.<IGameAnimatable>();
				_created = true;
				handleCreation();
			}
		}

		public function update( deltaTime : Number ) : void {
			_elapsedTime += deltaTime;
			if ( _animatables.length > 0 ) {
				var index : int = _animatables.length;
				var animatables : Vector.<IGameAnimatable> = _animatables.concat();
				while ( --index >= 0 )
					animatables[ index ].update( deltaTime );
			}
		}

		public function addAnimatable( animatable : IGameAnimatable ) : IGameAnimatable {
			const index : int = _animatables.indexOf( animatable );
			if ( index >= 0 )
				_animatables.splice( index, 1 );
			_animatables.push( animatable );
			return animatable;
		}

		public function hasAnimatable( animatable : IGameAnimatable ) : Boolean {
			return _animatables.indexOf( animatable ) >= 0;
		}

		public function removeAnimatable( animatable : IGameAnimatable ) : IGameAnimatable {
			const index : int = _animatables.indexOf( animatable );
			if ( index >= 0 )
				_animatables.splice( index, 1 );
			return animatable;
		}

		public function removeAllAnimatables() : void {
			_animatables.length = 0;
		}

		public function get elapsedTime() : Number {
			return _elapsedTime;
		}

		public function get currentDeltaTime() : Number {
			return ( getTimer() - _deltaToGlobalTime ) / 1000 - _elapsedTime;
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
				removeAllAnimatables();
				_animatables = null;
				_elapsedTime = 0;
				_deltaToGlobalTime = 0;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}
	}
}
