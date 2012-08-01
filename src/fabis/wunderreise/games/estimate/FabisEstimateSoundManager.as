package fabis.wunderreise.games.estimate {
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateSoundManager {
		
		private var _channel : SoundChannel;
		private var _request : URLRequest;
		public var _game : FabisEstimateGame;
		//protected var _frameNumber : int = 0;
		protected var _frameCounter : int = 0;
		/*private var _feedbackNumber : int = 0;
		private var _frameNumber : int = 0;
		public var _feedbackTime : int;
		private var _currentFeedbackStone : KolosseumStone;
		private var _points : int = 0;*/
		
		public var _gameOptions : FabisEstimateGameOptions;
		
		public function FabisEstimateSoundManager() {
			_channel = new SoundChannel();
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
		}
		
		public function playIntro() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("../sounds/games/cristo/intro.mp3");
			_sound.load(_request);
			_channel = _sound.play();
			_gameOptions.fabiSmall.startSynchronization();
			_gameOptions.fabiSmall.addEventListener( Event.ENTER_FRAME, handleFlip );
		}
		
		private function handleFlip( event : Event ) : void {
			
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.flipTime * 60 ){
				_gameOptions.fabiSmall.removeEventListener( Event.ENTER_FRAME, handleFlip );
				_gameOptions.fabiSmall.stopSynchronization();
				TweenLite.to( _gameOptions.fabiSmall.view, 1, {frame: _gameOptions.fabiSmall.view.totalFrames} );
				TweenLite.delayedCall( 1, _gameOptions.fabiCristoSmallContainer.parent.removeChild, [ _gameOptions.fabiCristoSmallContainer ] );
				TweenLite.delayedCall( 1, _game.initFabi );
				_frameCounter = 0;
			}
		}
		
		
		public function playExercise( exerciseNumber : int ) : void {
			var _sound : Sound = new Sound();
			
			switch( exerciseNumber ) {
				case 1 :
					_request = new URLRequest("../sounds/games/cristo/giraffesExercise.mp3");
					break;
				case 2 :
					_request = new URLRequest("../sounds/games/cristo/carsExercise.mp3");
					break;
			}
			
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleExerciseAnswer );
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleGameInstructions );
		}
		
		private function handleGameInstructions( event : Event ) : void {
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.showGiraffesTime * 60  ){
				_game.initGiraffes();
			}
			
			if( _frameCounter == _gameOptions.removeStatueTime * 60  ){
				_gameOptions.fabi.flip();
				TweenLite.delayedCall(1, _game.removeStatue );
			}
			
			if( _frameCounter == _gameOptions.showSockelTime * 60  ){
				_game.initGiraffesSockel();
			}
			
			if( _frameCounter == _gameOptions.showDoneButtonTime * 60  ){
				_game.initDoneButton();
				_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleGameInstructions );
			}
		}
		
		private function handleExerciseAnswer( event : Event ) : void {
			_channel.addEventListener( Event.SOUND_COMPLETE, handleExerciseAnswer );
			_game.initDrag();
		}
		
		/*private function handleEndOfQuestion( event : Event ) : void {
			_channel.removeEventListener( Event.SOUND_COMPLETE, handleEndOfQuestion );
			_game.initEndOfQuestion();
		}
		
		public function playFeedback( answerTrue : int, choosedAnswerTrue : Boolean, questionNumber : int ) : void {
			var _sound : Sound = new Sound();
			
			switch( questionNumber ){
				case 1:
				
					if( !answerTrue && !choosedAnswerTrue)
						_request = new URLRequest("../sounds/games/chichenItza/story1Right.mp3");
					else
						_request = new URLRequest("../sounds/games/chichenItza/story1Wrong.mp3");
					break;
					
				case 2:
				
					if( answerTrue && choosedAnswerTrue)
						_request = new URLRequest("../sounds/games/chichenItza/story2Right.mp3");
					else
						_request = new URLRequest("../sounds/games/chichenItza/story2Wrong.mp3");
					break;
					
				case 3:
				
					if( answerTrue && choosedAnswerTrue)
						_request = new URLRequest("../sounds/games/chichenItza/story3Right.mp3");
					else
						_request = new URLRequest("../sounds/games/chichenItza/story3Wrong.mp3");
					break;
			}
			
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleNextQuestion );
		}
		
		private function handleNextQuestion( event : Event ) : void {
			_channel.removeEventListener( Event.SOUND_COMPLETE, handleNextQuestion );
			_game.startQuestion();
		}
		
		public function playPoints( points : int ) : void {
			var _sound : Sound = new Sound();
			
			switch( points ){
				case 0:
				case 1:
					_request = new URLRequest("../sounds/games/endings/rightWrong12.mp3");
					break;
					
				case 2:
				case 3:
					_request = new URLRequest("../sounds/games/endings/rightWrong34.mp3");
					break;
			}
			
			_sound.load(_request);
			_channel = _sound.play();
			//_channel.addEventListener( Event.SOUND_COMPLETE, handleNextQuestion );
		}
		
		public function playRightOrWrongEffect( boolean : Boolean ) : void {
			var _sound : Sound = new Sound();
			if( boolean ) _request = new URLRequest("../sounds/games/effects/magicChime01.mp3");
			else _request = new URLRequest("../sounds/games/effects/magicChime01.mp3");
			_sound.load(_request);
			_sound.play();
		}
		
		public function playButtonClicked() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("../sounds/games/effects/InterfaceSound56.mp3");
			_sound.load(_request);
			_sound.play();
		}*/
	}
}
