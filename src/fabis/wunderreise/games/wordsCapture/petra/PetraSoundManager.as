package fabis.wunderreise.games.wordsCapture.petra {
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.media.Sound;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	/**
	 * @author Stefanie Drost
	 */
	public class PetraSoundManager {
		
		private var _channel : SoundChannel;
		private var _request : URLRequest;
		private var _feedbackNumber : int = 0;
		private var _frameNumber : int = 0;
		public var _feedbackTime : int;
		private var _currentFeedbackStone : PetraStone;
		private var _points : int = 0;
		
		public var _gameOptions : FabisWordsCaptureGameOptions;
		
		public function PetraSoundManager() {
			_channel = new SoundChannel();
		}
		
		public function initWithOptions( options : FabisWordsCaptureGameOptions ) : void {
			_gameOptions = options;
		}
		
		public function playIntro() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("../../sounds/Petra/Petra_Einleitung.mp3");
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			_gameOptions.fabi.startSynchronization();
		}
		
		private function handleSoundComplete( event: Event ) : void{
			_gameOptions.gameField.stopIntro();
			_gameOptions.fabi.stopSynchronization();
		}
		
		public function playStoneCatchedSound() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("../../sounds/sound11.mp3");
			_sound.load(_request);
			_sound.play();
		}
		
		public function playStoneFallSound() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("../../sounds/ploing.mp3");
			_sound.load(_request);
			_sound.play();
		}
		
		public function playFeedback( points : int ) : void {
			_points = points;
			
			var _sound : Sound = new Sound();
			_request = new URLRequest("../../sounds/Petra/Petra_Auswertung_UNFERTIG.mp3");
			_sound.load(_request);
			_channel = _sound.play();
			_gameOptions.fabi.startSynchronization();
			
			_feedbackTime = _gameOptions.feedbackTimes.shift() * 60;
			
			_gameOptions.gameField.addEventListener( Event.ENTER_FRAME, handleFeedbackSound );
			_channel.addEventListener( Event.SOUND_COMPLETE, handlePointsSound );
			
		}
		
		private function handleFeedbackSound( event: Event ) : void {
			
			_frameNumber++;
			
			if( _frameNumber == _feedbackTime ){
			
				var _stone : PetraStone;
				if( _currentFeedbackStone ) _currentFeedbackStone.removeHighlight();
				
				if( _feedbackNumber < _gameOptions.numrightStones ){
					
					_feedbackNumber++;
					var _stoneId : int;
					_stoneId = _gameOptions.feedbackOrder.shift();
					
					for each( _stone in _gameOptions.allPics){
						if( _stone.id == _stoneId ){
							
							_currentFeedbackStone = _stone;
							_currentFeedbackStone.highlight();
							_feedbackTime = _gameOptions.feedbackTimes.shift() * 60;
							break;
						}
					}
				}
				else{
					for each( _stone in _gameOptions.wrongStones ){
						_stone.highlight();
					}
					TweenLite.delayedCall(2, removeWrongHighlights);
					_gameOptions.gameField.removeEventListener( Event.ENTER_FRAME, handleFeedbackSound );
				}
			}
		}
		private function removeWrongHighlights() : void {
			var _stone : PetraStone;
			for each( _stone in _gameOptions.wrongStones ){
				_stone.removeHighlight();
			}
		}
		
		private function handlePointsSound( event: Event ) : void{
			_channel.removeEventListener( Event.SOUND_COMPLETE, handlePointsSound );
			_gameOptions.fabi.stopSynchronization();
			TweenLite.delayedCall(1, playPointsSound);
		}
		
		private function playPointsSound() : void {
			
			var _sound : Sound = new Sound();
			
			switch( _points ) {
				case 1:
				case 2:
				case 3:
					_request = new URLRequest("../../sounds/Petra/Petra_Feedback_3_und_weniger_richtig.mp3");
					break;
				case 4:
					_request = new URLRequest("../../sounds/Petra/Petra_Feedback_4_mal_richtig.mp3");
					break;
				case 5:
					_request = new URLRequest("../../sounds/Petra/Petra_Feedback_5_mal_richtig.mp3");
					break;
				case 6:
					_request = new URLRequest("../../sounds/Petra/Petra_Feedback_6_mal_richtig.mp3");
					break;
				case 7:
					_request = new URLRequest("../../sounds/Petra/Petra_Feedback_7_mal_richtig.mp3");
					break;
				case 8:
					_request = new URLRequest("../../sounds/Petra/Petra_Feedback_alles_richtig.mp3");
					break;
			}
			_sound.load(_request);
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleRemoveBasket );
			_gameOptions.fabi.startSynchronization();
		}
		
		public function handleRemoveBasket(  event: Event ) : void {	
			_channel.removeEventListener( Event.SOUND_COMPLETE, handleRemoveBasket );		
			_gameOptions.gameField.removeBasketFront();
			_gameOptions.fabi.stopSynchronization();
		}
		
		public function playCompletion() : void {
			var _sound : Sound = new Sound();
			_request = new URLRequest("../../sounds/Abschluss_Bilder_fangen.mp3");
			_sound.load(_request);
			_channel = _sound.play();
			_gameOptions.fabi.startSynchronization();
			_channel.addEventListener( Event.SOUND_COMPLETE, handleGameEnd );
		}
		
		private function handleGameEnd(  event: Event ) : void {	
			_channel.removeEventListener( Event.SOUND_COMPLETE, handleGameEnd );		
			_gameOptions.fabi.stopSynchronization();
		}
	}
}
