package fabis.wunderreise.scenes {
	import flash.filters.GlowFilter;
	import com.greensock.TweenLite;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumStone;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumGame;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumGameField;
	import flash.events.Event;
	import fabis.wunderreise.scenes.BaseScene;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisKolosseumWordsCapture extends BaseScene {
		
		protected var _game : KolosseumGame;
		protected var _gameField : KolosseumGameField;
		protected var _storage : *;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _menuButtons : FabisMenuButtons;
		protected var wordsCaptureOptions : FabisWordsCaptureGameOptions;
		
		public function FabisKolosseumWordsCapture() {
			super();
		}

		private function get view() : FabisKolosseumView {
			return FabisKolosseumView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisKolosseumView();
			_menuButtons = new FabisMenuButtons();
			view._kolosseum.gotoAndStop( 1 );
			
			_gameField = new KolosseumGameField();
			_gameField.init();
			
			wordsCaptureOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<KolosseumStone>();
			wordsCaptureOptions.allPics = new Vector.<KolosseumStone>();
			wordsCaptureOptions.wrongStones = new Vector.<KolosseumStone>();
			wordsCaptureOptions.rightStones = new Vector.<KolosseumStone>();
			wordsCaptureOptions.background = view._kolosseum;
			
			wordsCaptureOptions.fabi = new FabiView();
			wordsCaptureOptions.gameField = _gameField;
			wordsCaptureOptions.demoStartTime = 12;
			
			_lipSyncher = new FabisLipSyncher();
			wordsCaptureOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			//_eyeTwinkler.initWithEyes( _fabi._eyes );
			wordsCaptureOptions.eyeTwinkler = _eyeTwinkler;
			
			_game = new KolosseumGame();
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
				
				if( _storage.stampArray["colosseumStamp"] ){
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
				else{
					_storage.stampArray["colosseumStamp"] = false;
					_storage.finishedColosseum = true;
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
			_storage.lastStop = FabisTravelAnimationTarget.COLOSSEUM;
			gameCore.localStorage.saveStorage();
			
			if( _storage.stampArray["colosseumStamp"] ){
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
			if( !_game.hasCurrentSound() ){
				_helpSound = gameCore.soundCore.getSoundByName( "menuHelpWordsCapture" );
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
	}
}
