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
		private var _currentGame : *;
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
			_request = new URLRequest("sounds/games/cristo/intro.mp3");
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
				TweenLite.to( _gameOptions.fabiSmall.view, 1/2, {frame: _gameOptions.fabiSmall.view.totalFrames} );
				TweenLite.delayedCall( 1, _gameOptions.fabiCristoSmallContainer.parent.removeChild, [ _gameOptions.fabiCristoSmallContainer ] );
				TweenLite.delayedCall( 1, _game.initFabi );
				_frameCounter = 0;
			}
		}
		
		
		public function playExercise( exerciseNumber : int ) : void {
			var _sound : Sound = new Sound();
			
			
			switch( exerciseNumber ) {
				case 1 :
					_request = new URLRequest("sounds/games/cristo/giraffesExercise.mp3");
					_currentGame = FabisEstimateGiraffesExercise( _game.giraffesGame );
					break;
				case 2 :
					_request = new URLRequest("sounds/games/cristo/carsExercise.mp3");
					_currentGame = FabisEstimateCarsExercise( _game.carsGame );
					break;
			}
			
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleExerciseBegin );
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, _currentGame.handleGameInstructions );
		}
		
		public function playButtonClicked() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("sounds/games/effects/InterfaceSound56.mp3");
			_sound.load(_request);
			_sound.play();
		}
		
		private function handleExerciseBegin( event : Event ) : void {
			_channel.removeEventListener( Event.SOUND_COMPLETE, handleExerciseBegin );
			_game.initDrag();
		}
		
		public function playFeedback( exerciseNumber : int, pushedItemsNumber : int, attempt : int ) : void {
			var _sound : Sound = new Sound();
			var _tryAgain : Boolean = false;
			
			switch( exerciseNumber ){
				case 1:
					
					if( attempt == 2 ){
						if( pushedItemsNumber == _gameOptions.correctItemNumber )
							_request = new URLRequest("sounds/games/cristo/giraffesFeedbackRight.mp3");
						else
							_request = new URLRequest("sounds/games/cristo/giraffesFeedbackSecondAttemptWrong.mp3");
							
						TweenLite.delayedCall(5, _currentGame.showHeightBar );
					}
					else{
						if( pushedItemsNumber > _gameOptions.correctItemNumber ){
							_request = new URLRequest("sounds/games/cristo/giraffesFeedbackFirstAttemptTooMuch.mp3");
							_tryAgain = true;
						}
						else if( pushedItemsNumber < _gameOptions.correctItemNumber ){
							_request = new URLRequest("sounds/games/cristo/giraffesFeedbackFirstAttemptTooLittle.mp3");
							_tryAgain = true;
						}
						else{
							_request = new URLRequest("sounds/games/cristo/giraffesFeedbackRight.mp3");
							TweenLite.delayedCall(5, _currentGame.showHeightBar );
						}
					}
					break;
					
				case 2:
				
					if( attempt == 2 ){
						if( pushedItemsNumber == _gameOptions.correctItemNumber )
							_request = new URLRequest("sounds/games/cristo/carsFeedbackRight.mp3");
						else
							_request = new URLRequest("sounds/games/cristo/carsFeedbackSecondAttemptWrong.mp3");
						
						//TweenLite.delayedCall(1, _currentGame.showHeightBar );
					}
					else{
						if( pushedItemsNumber > _gameOptions.correctItemNumber ){
							_request = new URLRequest("sounds/games/cristo/carsFeedbackFirstAttemptTooMuch.mp3");
							_tryAgain = true;
						}
						else if( pushedItemsNumber < _gameOptions.correctItemNumber ){
							_request = new URLRequest("sounds/games/cristo/carsFeedbackFirstAttemptTooLittle.mp3");
							_tryAgain = true;
						}
						else{
							_request = new URLRequest("sounds/games/cristo/carsFeedbackRight.mp3");
							//TweenLite.delayedCall(1, _currentGame.showHeightBar );
						}
					}
					
					break;
			}
			
			_sound.load(_request);
			_channel = _sound.play();
			_game.secondTry = _tryAgain;
			_channel.addEventListener( Event.SOUND_COMPLETE, handleExerciseEnd );
		}
		
		private function handleExerciseEnd( event : Event ) : void {
			_channel.removeEventListener( Event.SOUND_COMPLETE, handleExerciseEnd );
			_game.endOfExercise();
		}
	}
}
