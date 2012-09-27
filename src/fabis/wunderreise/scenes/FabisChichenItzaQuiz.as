package fabis.wunderreise.scenes {
	import com.greensock.TweenLite;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.quiz.FabisChichenItzaQuizGame;
	import fabis.wunderreise.games.quiz.FabisQuizGameOptions;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChichenItzaQuiz extends BaseScene {
		
		protected var _game : FabisChichenItzaQuizGame;
		protected var _fabi : FabiView;
		protected var _skipButton : FabisSkipButton;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _storage : *;
		protected var _menuButtons : FabisMenuButtons;
		
		public function FabisChichenItzaQuiz() {
			super();
		}

		private function get view() : FabisChichenItzaView {
			return FabisChichenItzaView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisChichenItzaView();
			_menuButtons = new FabisMenuButtons();
			_fabi = new FabiView();
			_fabi.x = 80;
			_fabi.y = 300;
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._arm.gotoAndStop( 1 );
			view._chichenItzaContainer.addChild( _fabi );
			
			const quizOptions : FabisQuizGameOptions = new FabisQuizGameOptions();
			quizOptions.fabi = _fabi;
			quizOptions.view = view;
			quizOptions.switchTime = 20;
			quizOptions.questionNumber = 3;
			
			// right answers of questions -> 0 for false, 1 for true
			quizOptions.answers = new Array( 0, 1, 1);
			quizOptions.trueButtonStartTime = 27;
			
			_lipSyncher = new FabisLipSyncher();
			quizOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( _fabi._eyes );
			quizOptions.eyeTwinkler = _eyeTwinkler;
			
			_game = new FabisChichenItzaQuizGame();
			_game.initWithOptions( quizOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			quizOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view._chichenItzaContainer.addChild( _skipButton );
			view.addChild( _menuButtons );
			initMainMenu( _menuButtons );
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_game.soundCore = gameCore.soundCore;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
			_eyeTwinkler.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _eyeTwinkler );
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			_eyeTwinkler.stop();
			_lipSyncher.stop();
			_game.soundCore.stopAllSounds();
			
			if( _game._gameFinished ){
				_storage = gameCore.localStorage.getStorageObject();
				
				if( _storage.stampArray["chichenItzaStamp"] ){
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
				else{
					_storage.stampArray["chichenItzaStamp"] = false;
					_storage.finishedChichenItza = true;
					gameCore.localStorage.saveStorage();
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
			}
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			_eyeTwinkler.start();
			_game.start();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
	}
}
