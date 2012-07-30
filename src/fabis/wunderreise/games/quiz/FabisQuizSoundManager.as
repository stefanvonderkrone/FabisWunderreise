package fabis.wunderreise.games.quiz {

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizSoundManager {
		
		private var _channel : SoundChannel;
		private var _request : URLRequest;
		public var _game : FabisQuizGame;
		protected var _frameNumber : int = 0;
		/*private var _feedbackNumber : int = 0;
		private var _frameNumber : int = 0;
		public var _feedbackTime : int;
		private var _currentFeedbackStone : KolosseumStone;
		private var _points : int = 0;*/
		
		public var _gameOptions : FabisQuizGameOptions;
		
		public function FabisQuizSoundManager() {
			_channel = new SoundChannel();
		}
		
		public function initWithOptions( options : FabisQuizGameOptions ) : void {
			_gameOptions = options;
		}
		
		public function playIntro() : void {
			var _sound : Sound = new Sound();
//			_request = new URLRequest("../../sounds/Chichen_Itza/Chichen_Itza_Einleitung.mp3");
			_request = new URLRequest("sounds/games/chichenItza/intro.mp3");
//			_request = new URLRequest("../sounds/games/chichenItza/intro.mp3");
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleStopIntro );
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleSwitchViews );
			_gameOptions.fabi.startSynchronization();
		}
		
		private function handleStopIntro( event : Event ) : void {
			_gameOptions.fabi.stopSynchronization();
			_game.startQuestion();
		}
		
		public function handleSwitchViews( event : Event ) : void {
			_frameNumber++;
			
			if( _frameNumber == (_gameOptions.switchTime * 60) ){
				_game.switchToCloseView();
			}
		}
		
		public function playQuestion( questionNumber : int ) : void {
			var _sound : Sound = new Sound();
			
			switch( questionNumber ) {
				case 1 :
					_request = new URLRequest("../sounds/games/chichenItza/story1.mp3");
					break;
				case 2 :
					_request = new URLRequest("../sounds/games/chichenItza/story2.mp3");
					break;
				case 3 :
					_request = new URLRequest("../sounds/games/chichenItza/story3.mp3");
					break;
			}
			
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleEndOfQuestion );
		}
		
		private function handleEndOfQuestion( event : Event ) : void {
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
		}
	}
}
