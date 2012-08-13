package fabis.wunderreise.games.quiz {
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import flash.events.ProgressEvent;

	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.events.ErrorEvent;
	import flash.events.SampleDataEvent;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizGame extends Sprite implements ISoundItemDelegate {
		
		protected var _view : FabisCloseView;
		protected var _game : *;
		protected var _gameOptions : FabisQuizGameOptions;
		protected var _imageContainer : *;
		protected var _fabiClose : FabiQuizClose;
		protected var _currentQuestionNumber : int;
		protected var _trueButton : SimpleButton;
		protected var _points : int = 0;
		protected var _rightSymbol : Sprite;
		protected var _wrongSymbol : Sprite;
		
		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		protected var _questionSound : ISoundItem;
		protected var _questionSoundStarted : Boolean = false;
		protected var _buttonClickedSound : ISoundItem;
		protected var _buttonClickedSoundStarted : Boolean = false;
		protected var _answerSound : ISoundItem;
		protected var _answerSoundStarted : Boolean = false;
		protected var _feedbackSound : ISoundItem;
		protected var _feedbackSoundStarted : Boolean = false;
		protected var _pointsSound : ISoundItem;
		protected var _pointsSoundStarted : Boolean = false;
				
		protected var _soundCore : ISoundCore;
		protected var _frameCounter : int = 0;
		protected var _frameNumber : int = 0;
		
		public function FabisQuizGame() {
			
		}
		
		protected function get view() : FabisCloseView {
			return FabisCloseView( _view );
		}
		
		public function initWithOptions( options : FabisQuizGameOptions ) : void {
			_gameOptions = options;
			
			_view = new FabisCloseView();
			_fabiClose = new FabiQuizClose();
			_fabiClose._fabi = view._closeContainer._fabiClose;
			_fabiClose.init();
			_fabiClose._game = this;
			
			_currentQuestionNumber = 1;
		}
		
		public function skipIntro( event : MouseEvent ) : void {
			_introSound.stop();
			_introSoundStarted = false;
			switchToCloseView();
			startQuestion();
			initTrueButton();
		}
		
		public function start() : void {
			startIntro();
		}
		
		public function stop() : void {
			//_gameField.stop();
		}
		
		public function switchToCloseView() : void {
			_gameOptions.fabi.stopSynchronization();
			_gameOptions.view.addChild( view._closeContainer );
			_fabiClose.startSynchronization();
		}
		
		public function startIntro() : void {
			//_introSound = _soundCore.getSoundByName( "chichenItzaIntro" );
			_introSoundStarted = true;
			_introSound.delegate = this;
			_introSound.play();
			
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleSwitchViews );
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleTrueButtonView );
			_gameOptions.fabi.startSynchronization();
		}
		
		public function startQuestion() : void {
			
			_fabiClose.resetNose();
			
			if( _currentQuestionNumber <= _gameOptions.questionNumber ){
				_game.initImageContainer( _currentQuestionNumber );
				_rightSymbol.visible = false;
				_wrongSymbol.visible = false;
				_game.playQuestion( _currentQuestionNumber );
			}
			else{
				TweenLite.delayedCall(1, playPoints, [ _points ] );
			}
		}
		
		public function initEndOfQuestion() : void {
			_fabiClose.initNose( _gameOptions.answers[ 0 ] );
			_trueButton.addEventListener( MouseEvent.CLICK, onClickTrueButton );
		}
		
		public function initImageContainer( frameNumber : int ) : void {
		}
		
		public function initTrueButton() : void {
			_trueButton = new TrueButtonView();
			_trueButton.x = 450;
			_trueButton.y = 425;
			view._closeContainer.addChild( _trueButton );
		}
		
		private function onClickTrueButton( event : MouseEvent ) : void {
			_buttonClickedSound = _soundCore.getSoundByName("buttonClicked");
			_buttonClickedSound.play();
			resetTrueButton();
			_fabiClose.resetNose();
			checkAnswer( true );
		}
		
		public function resetTrueButton() : void {
			_trueButton.removeEventListener( MouseEvent.CLICK, onClickTrueButton );
		}
		
		public function checkAnswer( choosed : Boolean ) : void {
			var _rightAnswer : int = _gameOptions.answers.shift();
			
			if( ( _rightAnswer && choosed ) || ( !_rightAnswer && !choosed ) ){
				_points++;
			}
			
			if( _rightAnswer ){
				playRightOrWrongEffect( true );
				_imageContainer.setChildIndex( _rightSymbol, 3);
				_rightSymbol.visible = true;
			}
			else{
				playRightOrWrongEffect( false );
				_imageContainer.setChildIndex( _rightSymbol, 3);
				_wrongSymbol.visible = true;
			}
			
			_game.playFeedback( _rightAnswer, choosed, _currentQuestionNumber );
			//_fabiClose.startSynchronization();
			_currentQuestionNumber++;
		}

		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_fabiClose.stopSynchronization();
				TweenLite.delayedCall( 1, startQuestion );
			}
			if( _questionSoundStarted ){
				_questionSoundStarted = false;
				_fabiClose.stopSynchronization();
				initEndOfQuestion();
			}
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				_fabiClose.stopSynchronization();
				startQuestion();
			}
			if( _pointsSoundStarted ){
				_pointsSoundStarted = false;
				_fabiClose.stopSynchronization();
			}
		}

		public function reactOnSoundItemLoadComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemErrorEvent(evt : ErrorEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSampleDataEvent(evt : SampleDataEvent, soundItem : ISoundItem) : void {
		}
		
		public function handleSwitchViews( event : Event ) : void {
			_frameCounter++;
			
			if( _frameCounter == (_gameOptions.switchTime * 60) ){
				_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleSwitchViews );
				switchToCloseView();
				_frameCounter = 0;
			}
		}
		
		public function handleTrueButtonView( event : Event ) : void {
			_frameNumber++;
			
			if( _frameNumber == (_gameOptions.trueButtonStartTime * 60) ){
				_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleTrueButtonView );
				initTrueButton();
				_frameNumber = 0;
			}
		}
		
		public function playQuestion( questionNumber : int ) : void {
			_questionSoundStarted = true;
			_questionSound.delegate = this;
			_questionSound.play();
			_fabiClose.startSynchronization();
		}
		
		public function playRightOrWrongEffect( boolean : Boolean ) : void {
			if( boolean ) _answerSound = _soundCore.getSoundByName( "wrightAnswer" );
			else _answerSound = _soundCore.getSoundByName( "wrightAnswer" );
			_answerSoundStarted = true;
			_answerSound.play();
		}
		
		public function playFeedback( answerTrue : int, choosedAnswerTrue : Boolean, questionNumber : int ) : void {
			_feedbackSoundStarted = true;
			_feedbackSound.delegate = this;
			_feedbackSound.play();
			_fabiClose.startSynchronization();
		}
		
		public function playPoints( points : int ) : void {
			
			switch( points ){
				case 0:
				case 1:
					_pointsSound = _soundCore.getSoundByName( "endingsRightWrong12" );
					break;
					
				case 2:
				case 3:
					_pointsSound = _soundCore.getSoundByName( "endingsRightWrong34" );
					break;
			}
			_pointsSoundStarted = true;
			_pointsSound.delegate = this;
			_pointsSound.play();
			_fabiClose.startSynchronization();
		}
		
		public function set soundCore( soundCore : ISoundCore) : void {
			_soundCore = soundCore;
		}
		
		public function get soundCore() : ISoundCore {
			return _soundCore;
		}
	}
}
