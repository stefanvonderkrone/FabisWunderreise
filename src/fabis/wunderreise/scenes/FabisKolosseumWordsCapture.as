package fabis.wunderreise.scenes {
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.FabiWordsCapture;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumStone;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumGame;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumGameField;
	import flash.events.Event;
	import fabis.wunderreise.scenes.BaseScene;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisKolosseumWordsCapture extends BaseScene {
		
		protected var _game : KolosseumGame;
		protected var _gameField : KolosseumGameField;
		protected var _fabi : FabiWordsCapture;
		protected var _skipButton : FabisSkipButton;
		
		public function FabisKolosseumWordsCapture() {
			super();
		}

		private function get view() : FabisKolosseumView {
			return FabisKolosseumView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisKolosseumView();
			view._kolosseum.gotoAndStop( 1 );
			
			_gameField = new KolosseumGameField();
			_gameField.init();
			
			_fabi = new FabiWordsCapture();
			_fabi.view = view._fabi;
			_fabi.init();
			
			const wordsCaptureOptions : FabisWordsCaptureGameOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<KolosseumStone>();
			wordsCaptureOptions.allPics = new Vector.<KolosseumStone>();
			wordsCaptureOptions.wrongStones = new Vector.<KolosseumStone>();
			wordsCaptureOptions.rightStones = new Vector.<KolosseumStone>();
			wordsCaptureOptions.background = view._kolosseum;
			wordsCaptureOptions.fabi = _fabi;
			wordsCaptureOptions.gameField = _gameField;
			wordsCaptureOptions.demoStartTime = 12;
			
			_game = new KolosseumGame();
			_game.initWithOptions( wordsCaptureOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			wordsCaptureOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view.addChild( _skipButton );
			
			view._gameFieldContainer.addChild( _gameField.gameField );
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_game.soundCore = gameCore.soundCore;
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			_game.stop();
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			_game.start();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
	}
}
