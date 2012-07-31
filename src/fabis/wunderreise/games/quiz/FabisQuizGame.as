package fabis.wunderreise.games.quiz {
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizGame extends Sprite {
		
		protected var _view : FabisCloseView;
		protected var _gameOptions : FabisQuizGameOptions;
		protected var _soundManager : FabisQuizSoundManager;
		protected var _imageContainer : FabisQuizImageContainer;
		protected var _fabiClose : FabiQuizClose;
		protected var _currentQuestionNumber : int;
		protected var _trueButton : SimpleButton;
		protected var _points : int = 0;
		protected var _rightSymbol : Sprite;
		protected var _wrongSymbol : Sprite;
		
		public function FabisQuizGame() {
			
		}
		
		private function get view() : FabisCloseView {
			return FabisCloseView( _view );
		}
		
		public function initWithOptions( options : FabisQuizGameOptions ) : void {
			_gameOptions = options;
			
			_view = new FabisCloseView();
			_fabiClose = new FabiQuizClose();
			_fabiClose._fabi = view._closeContainer._fabiClose;
			_fabiClose.init();
			_fabiClose._game = this;
			
			_soundManager = new FabisQuizSoundManager();
			_soundManager.initWithOptions( _gameOptions );
			_soundManager._game = this;
			
			_currentQuestionNumber = 1;
		}
		
		public function start() : void {
			//TODO: add Intro
			//startIntro();
			switchToCloseView();
			startQuestion();
			initTrueButton();
		}
		
		public function stop() : void {
			//_gameField.stop();
		}
		
		public function switchToCloseView() : void {
			_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, _soundManager.handleSwitchViews );
			_gameOptions.view.removeChild( _gameOptions.view._chichenItzaContainer );
			_gameOptions.view.addChild( view._closeContainer );
			_fabiClose.startSynchronization();
			//_view = new FabisCloseView();
		}
		
		public function startIntro() : void {
			_soundManager.playIntro();
		}
		
		public function startQuestion() : void {
			
			//if( _trueButton ) view._closeContainer.removeChild( _trueButton );
			_fabiClose.resetNose();
			
			if( _currentQuestionNumber <= _gameOptions.questionNumber ){
				initImageContainer( _currentQuestionNumber );
				//initTrueButton();
				_rightSymbol.visible = false;
				_wrongSymbol.visible = false;
				
				_soundManager.playQuestion( _currentQuestionNumber );
			}
			else{
				TweenLite.delayedCall(1, _soundManager.playPoints, [ _points ] );
			}
			
		}
		
		public function initEndOfQuestion() : void {
			_fabiClose.initNose( _gameOptions.answers[ 0 ] );
			_trueButton.addEventListener( MouseEvent.CLICK, onClickTrueButton );
			
		}
		
		public function initImageContainer( frameNumber : int ) : void {
			if( frameNumber == 1 ){
				_imageContainer = new FabisQuizImageContainer();
				_rightSymbol = new RightSymbolView();
				_wrongSymbol = new WrongSymbolView();
				_rightSymbol.y = -5;
				_rightSymbol.x = 20;
				_wrongSymbol.y = -5;
				_wrongSymbol.x = 30;
				_imageContainer.x = 350;
				_imageContainer.y = 30;
				_imageContainer.addChild( _rightSymbol );
				_imageContainer.addChild( _wrongSymbol );
				
				view._closeContainer.addChild( _imageContainer );
				
			}
			_imageContainer.gotoAndStop( frameNumber );
		}
		
		public function initTrueButton() : void {
			_trueButton = new TrueButtonView();
			_trueButton.x = 450;
			_trueButton.y = 425;
			view._closeContainer.addChild( _trueButton );
		}
		
		private function onClickTrueButton( event : MouseEvent ) : void {
			_soundManager.playButtonClicked();
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
				_soundManager.playRightOrWrongEffect( true );
				_imageContainer.setChildIndex( _rightSymbol, 3);
				_rightSymbol.visible = true;
			}
			else{
				_soundManager.playRightOrWrongEffect( false );
				_imageContainer.setChildIndex( _rightSymbol, 3);
				_wrongSymbol.visible = true;
			}
				
			_soundManager.playFeedback( _rightAnswer, choosed, _currentQuestionNumber );
			_currentQuestionNumber++;
		}
	}
}
