package fabis.wunderreise.scenes {
	import fabis.wunderreise.games.wordsCapture.petra.PetraStone;
	import fabis.wunderreise.games.wordsCapture.petra.PetraGame;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.petra.PetraGameField;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	import flash.events.Event;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisPetraWordsCapture extends BaseScene {
		
		protected var _game : FabisWordsCaptureGame;
		protected var _gameField : PetraGameField;
		
		public function FabisPetraWordsCapture() {
			super();
		}

		private function get view() : FabisPetraView {
			return FabisPetraView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisPetraView();
			_gameField = new PetraGameField();
			_gameField.init();
			
			const wordsCaptureOptions : FabisWordsCaptureGameOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<PetraStone>();
			wordsCaptureOptions.allPics = new Vector.<PetraStone>();
			wordsCaptureOptions.gameField = _gameField;
			
			_game = new PetraGame();
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
