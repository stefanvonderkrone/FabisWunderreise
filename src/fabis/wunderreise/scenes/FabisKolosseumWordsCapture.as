package fabis.wunderreise.scenes {
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
		protected var _skipButton : FabisSkipButton;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _menuButtons : FabisMenuButtons;
		
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
			
			const wordsCaptureOptions : FabisWordsCaptureGameOptions = new FabisWordsCaptureGameOptions();
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
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			wordsCaptureOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view.addChild( _skipButton );
			
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
			super.handleStart();
			_eyeTwinkler.start();
			_game.start();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
	}
}
