package fabis.wunderreise.scenes {
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
		
		protected var _game : FabisWordsCaptureGame;
		protected var _gameField : KolosseumGameField;
		
		public function FabisKolosseumWordsCapture() {
			super();
		}

		private function get view() : FabisKolosseumView {
			return FabisKolosseumView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisKolosseumView();
			
			_gameField = new KolosseumGameField();
			_gameField.init();
			
			const wordsCaptureOptions : FabisWordsCaptureGameOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<KolosseumStone>();
			wordsCaptureOptions.allPics = new Vector.<KolosseumStone>();
			wordsCaptureOptions.wrongStones = new Vector.<KolosseumStone>();
			
			wordsCaptureOptions.gameField = _gameField;
			
			_game = new KolosseumGame();
			_game.initWithOptions( wordsCaptureOptions );
			
			view._gameFieldContainer.addChild( _gameField.gameField );
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
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
