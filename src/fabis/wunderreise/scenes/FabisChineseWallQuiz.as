package fabis.wunderreise.scenes {
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.quiz.FabisChineseWallQuizGame;
	import fabis.wunderreise.games.quiz.FabisQuizGameOptions;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChineseWallQuiz extends BaseScene {
		
		protected var _game : FabisChineseWallQuizGame;
		protected var _fabi : FabiView;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _storage : *;
		protected var _menuButtons : FabisMenuButtons;
		protected var quizOptions : FabisQuizGameOptions;
		
		public function FabisChineseWallQuiz() {
			super();
		}

		private function get view() : FabisChineseWallView {
			return FabisChineseWallView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisChineseWallView();
			_menuButtons = new FabisMenuButtons();			
			_fabi = new FabiView();
			_fabi.x = 80;
			_fabi.y = 300;
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._arm.gotoAndStop( 1 );
			view._chineseWallContainer.addChild( _fabi );
			
			quizOptions = new FabisQuizGameOptions();
			quizOptions.fabi = _fabi;
			quizOptions.view = view;
			quizOptions.switchTime = 26;
			quizOptions.questionNumber = 3;
			
			// right answers of questions -> 0 for false, 1 for true
			quizOptions.answers = new Array( 0, 1, 0);
			quizOptions.trueButtonStartTime = 33;
			
			_lipSyncher = new FabisLipSyncher();
			quizOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( _fabi._eyes );
			quizOptions.eyeTwinkler = _eyeTwinkler;
			
			_game = new FabisChineseWallQuizGame();
			_game.initWithOptions( quizOptions );
			
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
				
				if( _storage.stampArray["chineseWallStamp"] ){
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
				else{
					_storage.stampArray["chineseWallStamp"] = false;
					_storage.finishedChineseWall = true;
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
			_storage = gameCore.localStorage.getStorageObject();
			_storage.lastStop = FabisTravelAnimationTarget.CHINESE_WALL;
			gameCore.localStorage.saveStorage();
			
			if( _storage.stampArray["chineseWallStamp"] ){
				_skipButton = new FabisSkipButton();
				_skipButton.x = 900 - _skipButton.width - 20;
				_skipButton.y = 20;
				quizOptions.skipButton = _skipButton;
				_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
				view._chineseWallContainer.addChild( _skipButton );
				_skipButton.addEventListener( MouseEvent.MOUSE_OVER, highlightButton );
				_skipButton.addEventListener( MouseEvent.MOUSE_OUT, removeButtonHighlight );
				_skipButton.buttonMode = true;
			}
			
			super.handleStart();
			_eyeTwinkler.start();
			_game.start();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
		
		override protected function handleClickOnHelp() : void {
			if( !_game.hasCurrentSound() ){
				quizOptions.lipSyncher.start();
				_helpSound = gameCore.soundCore.getSoundByName( "menuHelpRightWrong" );
				_helpSound.delegate = this;
				_game._helpSoundStarted = true;
				super.handleClickOnHelp();
			}
		}
		
		override protected function handleClickOnPassport() : void {
			if( !( this is FabisPassport ) ){
				_storage = gameCore.localStorage.getStorageObject();
				_storage.currentGameScene = gameCore.director.currentScene;
				gameCore.localStorage.saveStorage();
				gameCore.director.pushScene( new FabisPassport() );
			}
		}
		
		override public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _game._helpSoundStarted ){
				_game._helpSoundStarted = false;
				quizOptions.lipSyncher.stop();
			}
		}
	}
}
