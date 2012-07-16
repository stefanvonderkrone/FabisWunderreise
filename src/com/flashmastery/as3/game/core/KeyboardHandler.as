package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IKeyboardHandler;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class KeyboardHandler extends Object implements IKeyboardHandler {

		protected var _stage : DisplayObjectContainer;
		protected var _keysPressed : Dictionary;
		protected var _availableKeys : Dictionary;
		protected var _altLeft : Boolean;
		protected var _altRight : Boolean;
		protected var _cmdLeft : Boolean;
		protected var _cmdRight : Boolean;
		protected var _ctrlLeft : Boolean;
		protected var _ctrlRight : Boolean;
		protected var _shiftLeft : Boolean;
		protected var _shiftRight : Boolean;
		protected var _arrowDown : Boolean;
		protected var _arrowLeft : Boolean;
		protected var _arrowRight : Boolean;
		protected var _arrowUp : Boolean;
		protected var _space : Boolean;
		protected var _enabled : Boolean;
		protected var _created : Boolean;

		public function KeyboardHandler() {
			create();
		}

		protected function initializeKeys() : void {
			const keyboardXML : XML = describeType( KeyCodes );
			const constants : XMLList = keyboardXML..constant;
			var index : int = constants.length();
			var constant : XML;
			var constantName : String;
			while ( --index >= 0 ) {
				constant = constants[ index ];
				if ( constant.@type.toString() == "uint" ) {
					constantName = constant.@name.toString();
					_keysPressed[ KeyCodes[ constantName ] ] = false;
					_availableKeys[ constantName ] = KeyCodes[ constantName ];
				}
			}
		}

		protected function reset() : void {
			for (var keyName : String in _availableKeys)
				_keysPressed[ _availableKeys[ keyName ] ] = false;
			_space = false;
			_altLeft = false;
			_altRight = false;
			_cmdLeft = false;
			_cmdRight = false;
			_ctrlLeft = false;
			_ctrlRight = false;
			_shiftLeft = false;
			_shiftRight = false;
			_arrowUp = false;
			_arrowDown = false;
			_arrowLeft = false;
			_arrowRight = false;
		}

		public function isKeyPressed( key : Object ) : Boolean {
			if ( key is String ) {
				key = String( key ).toUpperCase();
				return _availableKeys.hasOwnProperty( key ) ? _keysPressed[ _availableKeys[ key ] ] : false;
			} else if ( !isNaN( int( key ) ) && _keysPressed.hasOwnProperty( key ) )
				return _keysPressed[ key ];
			return false;
		}

		public function setupWithStage( stage : DisplayObjectContainer ) : void {
			if ( stage.stage != null ) setStage( stage.stage );
			else {
				_stage = stage;
				_stage.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			}
		}

		protected function addedToStageHandler( evt : Event ) : void {
			_stage.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			setStage( _stage.stage );
		}

		protected function setStage( stage : Stage ) : void {
			_stage = stage;
			if ( _enabled ) {
				_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
				_stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			}
		}

		protected function keyUpHandler( evt : KeyboardEvent ) : void {
			_keysPressed[ evt.keyCode ] = false;
			if ( evt.keyCode == KeyCodes.SPACE )
				_space = false;
			else if ( evt.keyCode == KeyCodes.ALTERNATE ) {
				if ( evt.keyLocation <= 1 )
					_altLeft = false;
				else _altRight = false;
			} else if ( evt.keyCode == KeyCodes.COMMAND ) {
				if ( evt.keyLocation <= 1 )
					_cmdLeft = false;
				else _cmdRight = false;
			} else if ( evt.keyCode == KeyCodes.CONTROL ) {
				if ( evt.keyLocation <= 1 )
					_ctrlLeft = false;
				else _ctrlRight = false;
			} else if ( evt.keyCode == KeyCodes.SHIFT ) {
				if ( evt.keyLocation <= 1 )
					_shiftLeft = false;
				else _shiftRight = false;
			} else if ( evt.keyCode == KeyCodes.UP )
				_arrowUp = false;
			else if ( evt.keyCode == KeyCodes.DOWN )
				_arrowDown = false;
			else if ( evt.keyCode == KeyCodes.LEFT )
				_arrowLeft = false;
			else if ( evt.keyCode == KeyCodes.RIGHT )
				_arrowRight = false;
		}

		protected function keyDownHandler( evt : KeyboardEvent ) : void {
			_keysPressed[ evt.keyCode ] = true;
			if ( evt.keyCode == KeyCodes.SPACE )
				_space = true;
			else if ( evt.keyCode == KeyCodes.ALTERNATE ) {
				if ( evt.keyLocation <= 1 )
					_altLeft = true;
				else _altRight = true;
			} else if ( evt.keyCode == KeyCodes.COMMAND ) {
				if ( evt.keyLocation <= 1 )
					_cmdLeft = true;
				else _cmdRight = true;
			} else if ( evt.keyCode == KeyCodes.CONTROL ) {
				if ( evt.keyLocation <= 1 )
					_ctrlLeft = true;
				else _ctrlRight = true;
			} else if ( evt.keyCode == KeyCodes.SHIFT ) {
				if ( evt.keyLocation <= 1 )
					_shiftLeft = true;
				else _shiftRight = true;
			} else if ( evt.keyCode == KeyCodes.UP )
				_arrowUp = true;
			else if ( evt.keyCode == KeyCodes.DOWN )
				_arrowDown = true;
			else if ( evt.keyCode == KeyCodes.LEFT )
				_arrowLeft = true;
			else if ( evt.keyCode == KeyCodes.RIGHT )
				_arrowRight = true;
		}

		final public function get altLeft() : Boolean {
			return _altLeft;
		}

		final public function get altRight() : Boolean {
			return _altRight;
		}

		final public function get cmdLeft() : Boolean {
			return _cmdLeft;
		}

		final public function get cmdRight() : Boolean {
			return _cmdRight;
		}

		final public function get ctrlLeft() : Boolean {
			return _ctrlLeft;
		}

		final public function get ctrlRight() : Boolean {
			return _ctrlRight;
		}

		final public function get shiftLeft() : Boolean {
			return _shiftLeft;
		}

		final public function get shiftRight() : Boolean {
			return _shiftRight;
		}

		final public function get arrowDown() : Boolean {
			return _arrowDown;
		}

		final public function get arrowLeft() : Boolean {
			return _arrowLeft;
		}

		final public function get arrowRight() : Boolean {
			return _arrowRight;
		}

		final public function get arrowUp() : Boolean {
			return _arrowUp;
		}

		final public function get space() : Boolean {
			return _space;
		}

		final public function get enabled() : Boolean {
			return _enabled;
		}

		final public function get alt() : Boolean {
			return _altLeft || _altRight;
		}

		final public function get cmd() : Boolean {
			return _cmdLeft || _cmdRight;
		}

		final public function get ctrl() : Boolean {
			return _ctrlLeft || _ctrlRight;
		}

		final public function get shift() : Boolean {
			return _shiftLeft || _shiftRight;
		}

		public function set enabled( enabled : Boolean ) : void {
			_enabled = enabled;
			if ( _enabled ) {
				_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
				_stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			} else {
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
				_stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
				reset();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				enabled = false;
				_stage = null;
				_keysPressed = null;
				_availableKeys = null;
				_created = false;
			}
		}

		final public function create() : void {
			if ( !_created ) {
				_keysPressed = new Dictionary();
				_availableKeys = new Dictionary();
				initializeKeys();
				_created = true;
				handleCreation();
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}
	}
}
