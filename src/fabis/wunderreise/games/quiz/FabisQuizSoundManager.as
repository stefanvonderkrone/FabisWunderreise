package fabis.wunderreise.games.quiz {
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizSoundManager {
		
		private var _channel : SoundChannel;
		private var _request : URLRequest;
		public var _game : FabisQuizGame;
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
			_request = new URLRequest("../../sounds/Chichen_Itza/Chichen_Itza_Einleitung.mp3");
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleStopIntro );
			_gameOptions.fabi.startSynchronization();
		}
		
		private function handleStopIntro( event : Event ) : void {
			_gameOptions.fabi.stopSynchronization();
			_game.startGame();
		}
	}
}
