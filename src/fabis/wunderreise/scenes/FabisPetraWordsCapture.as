package fabis.wunderreise.scenes {
	import flash.display.MovieClip;
	import fabis.wunderreise.games.wordsCapture.FabiWordsCapture;
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
		protected var _fabi : FabiWordsCapture;
		protected var _fabiView : FabiView;
		
		public function FabisPetraWordsCapture() {
			super();
		}

		private function get view() : FabisPetraView {
			return FabisPetraView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisPetraView();
			//view._petra.gotoAndStop( 1 );
			
			_gameField = new PetraGameField();
			_gameField.init();
			
			_fabiView = new FabiView();
			_fabiView.x = 110;
			_fabiView.y = 260;
			view.addChild( _fabiView );
			
			_fabi = new FabiWordsCapture();
			_fabi.view = _fabiView;
			_fabi.init();
			
			const wordsCaptureOptions : FabisWordsCaptureGameOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<PetraStone>();
			wordsCaptureOptions.allPics = new Vector.<PetraStone>();
			wordsCaptureOptions.wrongStones = new Vector.<PetraStone>();
			wordsCaptureOptions.rightStones = new Vector.<PetraStone>();
			//wordsCaptureOptions.background = view._petra;
			wordsCaptureOptions.fabi = _fabi;
			wordsCaptureOptions.gameField = _gameField;
			wordsCaptureOptions.demoStartTime = 10;
			
			_game = new PetraGame();
			_game.initWithOptions( wordsCaptureOptions );
			
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
