package fabis.wunderreise.games.quiz {
	import flash.display.MovieClip;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import fabis.wunderreise.sound.IFabisLipSyncherDelegate;
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
	public class FabisQuizGame extends Sprite implements ISoundItemDelegate, IFabisLipSyncherDelegate {
		
		public var _gameFinished : Boolean = false;
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
		public var _helpSoundStarted : Boolean = false;
		protected var _newQuestionSound : ISoundItem;
		protected var _removeQuestionSound : ISoundItem;
				
		protected var _soundCore : ISoundCore;
		protected var _frameCounter : int = 0;
		protected var _frameNumber : int = 0;
		
		protected var _closeView : Boolean = false;
		
		public function FabisQuizGame() {
			
		}
		
		protected function get view() : FabisCloseView {
			return FabisCloseView( _view );
		}
		
		public function initWithOptions( options : FabisQuizGameOptions ) : void {
			_gameOptions = options;
			
			_view = new FabisCloseView();
			_fabiClose = new FabiQuizClose();
			_fabiClose._fabi = view._closeContainer._fabi;
			_fabiClose.init();
			_fabiClose._game = this;
			
			_currentQuestionNumber = 1;
		}
		
		public function skipIntro( event : MouseEvent ) : void {
			_introSound.stop();
			_introSoundStarted = false;
			_buttonClickedSound = _soundCore.getSoundByName("buttonClicked");
			_buttonClickedSound.play();
			_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleSwitchViews );
			_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleTrueButtonView );
			switchToCloseView();
			TweenLite.delayedCall( 0.7, startQuestion );
			TweenLite.delayedCall( 0.7, initTrueButton );
		}
		
		public function start() : void {
			startIntro();
		}
		
		public function switchToCloseView() : void {
			_gameOptions.lipSyncher.stop();
			
			_gameOptions.view.addChild( view._closeContainer );
			_gameOptions.fabiClose = _fabiClose._fabi;
			_closeView = true;
			_gameOptions.eyeTwinkler.initWithEyes( _fabiClose._fabi._eyes );
			_gameOptions.lipSyncher.start();
			
			_newQuestionSound = _soundCore.getSoundByName("introPlop");
			_removeQuestionSound = _soundCore.getSoundByName("removeQuestion");
		}
		
		public function startIntro() : void {
			_gameOptions.lipSyncher.delegate = this;
			
			_introSoundStarted = true;
			_introSound.delegate = this;
			_introSound.play();
			
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleSwitchViews );
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleTrueButtonView );
			
			_gameOptions.lipSyncher.start();
		}
		
		public function startQuestion() : void {
			
			_fabiClose.resetNose();
			
			if( _currentQuestionNumber <= _gameOptions.questionNumber ){
				_newQuestionSound.play();
				_game.initImageContainer( _currentQuestionNumber );
				_imageContainer.visible = true;
				_rightSymbol.visible = false;
				_wrongSymbol.visible = false;
				TweenLite.delayedCall( 0.5, _game.playQuestion, [ _currentQuestionNumber ]);
			}
			else{
				TweenLite.delayedCall(1, playPoints, [ _points ] );
			}
		}
		
		public function removeCurrentQuestion() : void {
			_fabiClose.resetNose();
			_removeQuestionSound.play();
			_imageContainer.visible = false;
		}
		
		public function initEndOfQuestion() : void {
			_fabiClose.initNose( _gameOptions.answers[ 0 ] );
			_trueButton.enabled = true;
			_trueButton.addEventListener( MouseEvent.CLICK, onClickTrueButton );
		}
		
		public function initImageContainer( frameNumber : int ) : void {
		}
		
		public function initTrueButton() : void {
			_trueButton = new TrueButtonView();
			_trueButton.x = 460;
			_trueButton.y = 405;
			_trueButton.enabled = false;
			var _buttonEffectSound : ISoundItem = _soundCore.getSoundByName("introPlop");
			_buttonEffectSound.play();
			view._closeContainer.addChild( _trueButton );
		}
		
		private function onClickTrueButton( event : MouseEvent ) : void {
			if( !_helpSoundStarted ){
				_buttonClickedSound = _soundCore.getSoundByName("buttonClicked");
				_buttonClickedSound.play();
				resetTrueButton();
				_fabiClose.resetNose();
				checkAnswer( true );
			}
		}
		
		public function resetTrueButton() : void {
			_trueButton.enabled = false;
			_trueButton.removeEventListener( MouseEvent.CLICK, onClickTrueButton );
		}
		
		public function checkAnswer( choosed : Boolean ) : void {
			var _rightAnswer : int = _gameOptions.answers.shift();
			
			if( ( _rightAnswer && choosed ) || ( !_rightAnswer && !choosed ) ){
				_points++;
			}
			
			if( _rightAnswer ){
				TweenLite.delayedCall( 1, reactOnAnswer, [ _rightAnswer, choosed ]);
				playRightOrWrongEffect( true );
				//_imageContainer.setChildIndex( _rightSymbol, _imageContainer.numChildren-1 );
				//_rightSymbol.visible = true;
				
			}
			else{
				TweenLite.delayedCall( 1.5, reactOnAnswer, [ _rightAnswer, choosed ]);
				playRightOrWrongEffect( false );
				//TweenLite.to( _fabiClose._fabi._nose, 1, {frame: _fabiClose._fabi._nose.totalFrames});
				//_imageContainer.setChildIndex( _wrongSymbol, _imageContainer.numChildren-1);
				//_wrongSymbol.visible = true;
				
			}
		}
		
		public function reactOnAnswer(  answerTrue : int, choosedAnswerTrue : Boolean ) : void {
			_game.playFeedback( answerTrue, choosedAnswerTrue, _currentQuestionNumber );
			_currentQuestionNumber++;
		}
		
		public function playRightOrWrongEffect( boolean : Boolean ) : void {
			if( boolean ){
				// _answerSound = _soundCore.getSoundByName( "rightAnswer" );
				 _imageContainer.setChildIndex( _rightSymbol, _imageContainer.numChildren-1 );
				_rightSymbol.visible = true;
			}
			else {
				_answerSound = _soundCore.getSoundByName( "nose" );
				TweenLite.to( _fabiClose._fabi._nose, 1, {frame: _fabiClose._fabi._nose.totalFrames});
				_imageContainer.setChildIndex( _wrongSymbol, _imageContainer.numChildren-1);
				_wrongSymbol.visible = true;
				_answerSoundStarted = true;
				_answerSound.play();
			}
		}

		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				TweenLite.delayedCall( 1, startQuestion );
			}
			if( _questionSoundStarted ){
				_questionSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				initEndOfQuestion();
			}
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				TweenLite.delayedCall(1 , removeCurrentQuestion );
				TweenLite.delayedCall(2 , startQuestion );
			}
			if( _pointsSoundStarted ){
				_pointsSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				_game.stop();
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
			_gameOptions.lipSyncher.start();
		}
		
		
		
		public function playFeedback( answerTrue : int, choosedAnswerTrue : Boolean, questionNumber : int ) : void {
			_feedbackSoundStarted = true;
			_feedbackSound.delegate = this;
			_feedbackSound.play();
			_gameOptions.lipSyncher.start();
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
			_gameOptions.lipSyncher.start();
		}
		
		public function set soundCore( soundCore : ISoundCore) : void {
			_soundCore = soundCore;
		}
		
		public function get soundCore() : ISoundCore {
			return _soundCore;
		}

		public function reactOnCumulatedSpectrum(cumulatedSpectrum : Number) : void {
			var lips : MovieClip;
			if( _closeView ) 
				lips = _gameOptions.fabiClose._lips;
			else
				lips = _gameOptions.fabi._lips;
			
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}

		public function reactOnStart(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnStop(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnDisposal(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnAddedToDelegater(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnRemovalFromDelegater(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnGameFinished(result : Object, gameCore : IGameCore) : void {
		}

		public function get gameCore() : IGameCore {
			return null;
		}

		public function set gameCore(gameCore : IGameCore) : void {
		}
		
		public function hasCurrentSound() : Boolean {
			if( _introSoundStarted || _feedbackSoundStarted || _pointsSoundStarted
				|| _questionSoundStarted ){
				return true;
			}
			return false;
		}
	}
}
