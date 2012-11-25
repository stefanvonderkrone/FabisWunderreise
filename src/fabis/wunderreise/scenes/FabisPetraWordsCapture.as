package fabis.wunderreise.scenes {

	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.petra.PetraGame;
	import fabis.wunderreise.games.wordsCapture.petra.PetraGameField;
	import fabis.wunderreise.games.wordsCapture.petra.PetraStone;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;

	import com.greensock.TweenLite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisPetraWordsCapture extends BaseScene {
		
		protected var _game : PetraGame;
		protected var _gameField : PetraGameField;
		protected var _fabiView : FabiView;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _menuButtons : FabisMenuButtons;
		protected var _storage : Object;
		protected var wordsCaptureOptions : FabisWordsCaptureGameOptions;
		
		public function FabisPetraWordsCapture() {
			super();
		}

		private function get view() : FabisPetraView {
			return FabisPetraView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisPetraView();
			_menuButtons = new FabisMenuButtons();
			view._petra.gotoAndStop( 1 );
			
			_gameField = new PetraGameField();
			_gameField.init();
			
			wordsCaptureOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<PetraStone>();
			wordsCaptureOptions.allPics = new Vector.<PetraStone>();
			wordsCaptureOptions.wrongStones = new Vector.<PetraStone>();
			wordsCaptureOptions.rightStones = new Vector.<PetraStone>();
			wordsCaptureOptions.background = view._petra;
			wordsCaptureOptions.fabi = new FabiView();
			wordsCaptureOptions.gameField = _gameField;
			wordsCaptureOptions.demoStartTime = 10;
			
			_lipSyncher = new FabisLipSyncher();
			wordsCaptureOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			//_eyeTwinkler.initWithEyes( _fabi._eyes );
			wordsCaptureOptions.eyeTwinkler = _eyeTwinkler;
			
			_game = new PetraGame();
			_game.initWithOptions( wordsCaptureOptions );
			_gameField._game = _game;
			
			
			view._gameFieldContainer.addChild( _gameField.gameField );
			view.addChild( wordsCaptureOptions.fabi );
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
				
				if( _storage.stampArray["petraStamp"] ){
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
				else{
					_storage.stampArray["petraStamp"] = false;
					_storage.finishedPetra = true;
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
			_storage.lastStop = FabisTravelAnimationTarget.PETRA;
			gameCore.localStorage.saveStorage();
			
			if( _storage.stampArray["petraStamp"] ){
				_skipButton = new FabisSkipButton();
				_skipButton.x = 900 - _skipButton.width - 20;
				_skipButton.y = 20;
				wordsCaptureOptions.skipButton = _skipButton;
				_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
				view.addChild( _skipButton );
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
		
		override protected function handleClickOnMap() : void {
			_gameField.removeAllEventListener();
			super.handleClickOnMap();
		}
		
		override protected function handleClickOnHelp() : void {
			_helpSound = gameCore.soundCore.getSoundByName( "menuHelpWordsCapture" );
			super.handleClickOnHelp();
		}
		
		override protected function handleClickOnPassport() : void {
			if( !( this is FabisPassport ) ){
				_storage = gameCore.localStorage.getStorageObject();
				_storage.currentGameScene = gameCore.director.currentScene;
				gameCore.localStorage.saveStorage();
				gameCore.director.pushScene( new FabisPassport() );
			}
		}
	}
}
