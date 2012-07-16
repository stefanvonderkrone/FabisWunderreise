package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.delegates.IGameDelegate;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class InteractiveGameObject extends Object implements IInteractiveGameObject {
		
		protected var _delegate : IGameDelegate;
		protected var _gameCore : IGameCore;
		protected var _isRunning : Boolean;
		protected var _created : Boolean;
		
		public function InteractiveGameObject() {
			create();
		}
		
		final public function create() : void {
			if ( !_created ) {
				_isRunning = false;
				_created = true;
				handleCreation();
			}
		}

		protected function handleCreation() : void {
		}

		protected function handleDisposal() : void {
		}

		protected function handleStart() : void {
		}

		protected function handleStop() : void {
		}

		final public function dispose() : void {
			if ( _created ) {
				if ( _delegate != null ) _delegate.reactOnDisposal( this );
				handleDisposal();
				_delegate = null;
				_gameCore = null;
				_created = false;
			}
		}

		final public function start() : void {
			if ( !_isRunning ) {
				if ( _delegate != null ) _delegate.reactOnStart( this );
				handleStart();
				_isRunning = true;
			}
		}

		final public function stop() : void {
			if ( _isRunning ) {
				if ( _delegate != null ) _delegate.reactOnStop( this );
				handleStop();
				_isRunning = false;
			}
		}

		final public function get delegate() : IGameDelegate {
			return _delegate;
		}

		final public function set delegate( delegate : IGameDelegate ) : void {
			if ( _delegate != null )
				_delegate.reactOnRemovalFromDelegater( this );
			_delegate = delegate;
			if ( _delegate != null ) {
				_delegate.gameCore = _gameCore;
				_delegate.reactOnAddedToDelegater( this );
			}
		}

		final public function get gameCore() : IGameCore {
			return _gameCore;
		}

		final public function set gameCore( gameCore : IGameCore ) : void {
			_gameCore = gameCore;
			if ( _delegate != null )
				_delegate.gameCore = _gameCore;
		}

		final public function get isRunning() : Boolean {
			return _isRunning;
		}
	}
}
