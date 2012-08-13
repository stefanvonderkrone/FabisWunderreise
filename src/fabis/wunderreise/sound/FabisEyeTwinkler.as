package fabis.wunderreise.sound {

	import com.flashmastery.as3.game.core.InteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.core.IGameAnimatable;

	import flash.display.MovieClip;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisEyeTwinkler extends InteractiveGameObject implements IGameAnimatable {
		
		protected static var STATE_IDLE : uint = 0;
		protected static var STATE_TWINKLE : uint = 1;
		protected static var STATE_TWINKLE_BACK : uint = 2;
		protected static var ANIMATION_POSSIBILITY : Number = 0.03;

		protected var _eyes : MovieClip;
		protected var _state : uint;
		protected var _updateInterval : uint;
		protected var _currentFrame : uint;

		public function FabisEyeTwinkler() {
			super();
		}
		
		override protected function handleStart() : void {
			
		}

		override protected function handleStop() : void {
			
		}

		override protected function handleDisposal() : void {
			_eyes = null;
			_state = 0;
			_updateInterval = 0;
			_currentFrame = 0;
		}

		override protected function handleCreation() : void {
			_state = STATE_IDLE;
			_updateInterval = 4;
			_currentFrame = 0;
		}
		
		public function initWithEyes( eyes : MovieClip ) : void {
			_eyes = eyes;
		}

		public function update( deltaTime : Number ) : void {
			if ( !_isRunning ) return;
			_currentFrame++;
			if ( _currentFrame == _updateInterval ) {
				_currentFrame = 0;
				if ( _eyes == null )
					return;
				if ( _state == STATE_IDLE && Math.random() < ANIMATION_POSSIBILITY ) {
					_state = STATE_TWINKLE;
				} else if ( _state == STATE_TWINKLE ) {
					_eyes.gotoAndStop( _eyes.currentFrame + 1 );
					if ( _eyes.currentFrame == 3 )
						_state = STATE_TWINKLE_BACK;
				} else if ( _state == STATE_TWINKLE_BACK ) {
					_eyes.gotoAndStop( _eyes.currentFrame - 1 );
					if ( _eyes.currentFrame == 1 )
						_state = STATE_IDLE;
				}
			}
		}

		public function get updateInterval() : uint {
			return _updateInterval;
		}

		public function set updateInterval( updateInterval : uint ) : void {
			_updateInterval = updateInterval;
		}
	}
}
