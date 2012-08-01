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
		
		protected var _bytes : ByteArray; 
		protected var _frameCounter : int = 0;
		protected var _spec : Number = 0;
		protected var _answerIsTrue : int;
		
		public var _fabi : MovieClip;
		public var _game : FabisQuizGame;
		
		public function FabiQuizClose() {
			
		}
		
		public function init() : void {
			_fabi.gotoAndStop( 1 );
			_fabi._fabiCloseMouth.gotoAndStop( 1 );
			_bytes = new ByteArray();
		}
		
		public function initNose( answerTrue : int ) : void {
			_answerIsTrue = answerTrue;
			_fabi._nose.buttonMode = true;
			_fabi.addEventListener( MouseEvent.CLICK, onClickNose );
		}
		
		public function resetNose() : void {
			TweenLite.to(_fabi, 0.5, {frame: 1});
			_fabi._nose.buttonMode = false;
			_fabi.removeEventListener( MouseEvent.CLICK, onClickNose );
		}
		
		private function onClickNose( event : MouseEvent ) : void {
			_fabi.removeEventListener( MouseEvent.CLICK, onClickNose );
			_game.resetTrueButton();
			if( !_answerIsTrue ){
				TweenLite.to(_fabi, 0.5, {frame: _fabi.totalFrames});
			}
			_fabi._nose.buttonMode = false;
			_game.checkAnswer( false );
		}
		
		public function startSynchronization() : void {
			addEventListener( Event.ENTER_FRAME, handleSynchronization );
		}
		
		public function stopSynchronization() : void {
			removeEventListener( Event.ENTER_FRAME, handleSynchronization );
			_fabi._fabiCloseMouth.gotoAndStop( 1 );
		}
		
		private function handleSynchronization( event : Event ) :void {
			_frameCounter++;
			
			_spec = 0;
			SoundMixer.computeSpectrum( _bytes, false, 0 );
			
			for (var i:int = 0; i < 512; i++) {
				_spec += _bytes.readFloat();
			}
			
			if( _frameCounter % 5 == 0 ){
				if ( _spec > -0.4 ) {
					_fabi._fabiCloseMouth.gotoAndStop( 1 );
				}
				else if( _spec > -0.5 ){
					_fabi._fabiCloseMouth.gotoAndStop( 2 );
	 			}	
				else if( _spec > -0.9 ){
					_fabi._fabiCloseMouth.gotoAndStop( 3 );
	 			}
				else{
					_fabi._fabiCloseMouth.gotoAndStop( 4 );		
				}
			}
		}
	}
}