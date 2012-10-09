package fabis.wunderreise.games.quiz {
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * @author Stefanie Drost
	 */
	public class FabiQuizClose extends MovieClip {
		
		protected var _answerIsTrue : int;
		
		public var _fabi : FabiClose;
		public var _game : FabisQuizGame;
		
		public function FabiQuizClose() {
			
		}
		
		public function init() : void {
			_fabi._lips.gotoAndStop( 1 );
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
		}
		
		public function initNose( answerTrue : int ) : void {
			_answerIsTrue = answerTrue;
			_fabi._noseContainer.buttonMode = true;
			_fabi.addEventListener( MouseEvent.CLICK, onClickNose );
		}
		
		public function resetNose() : void {
			TweenLite.to(_fabi._nose, 1, {frame: 1});
			_fabi._noseContainer.buttonMode = false;
			_fabi.removeEventListener( MouseEvent.CLICK, onClickNose );
		}
		
		private function onClickNose( event : MouseEvent ) : void {
			if( !_game._helpSoundStarted ){
				_fabi.removeEventListener( MouseEvent.CLICK, onClickNose );
				_game.resetTrueButton();
				if( !_answerIsTrue ){
					TweenLite.to(_fabi._nose, 0.5, {frame: _fabi._nose.totalFrames});
				}
				_fabi._noseContainer.buttonMode = false;
				_game.checkAnswer( false );
			}
			
		}
	}
}
