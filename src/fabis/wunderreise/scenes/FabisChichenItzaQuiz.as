package fabis.wunderreise.scenes {
	
	import fabis.wunderreise.games.quiz.FabiQuiz;
	import fabis.wunderreise.games.quiz.FabisQuizGameOptions;
	import fabis.wunderreise.games.quiz.FabisQuizGame;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChichenItzaQuiz extends BaseScene {
		
		protected var _game : FabisQuizGame;
		//protected var _gameField : KolosseumGameField;
		protected var _fabi : FabiQuiz;
		
		public function FabisChichenItzaQuiz() {
			super();
		}

		private function get view() : FabisChichenItzaView {
			return FabisChichenItzaView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisChichenItzaView();
			/*view._kolosseum.gotoAndStop( 1 );
			
			_gameField = new KolosseumGameField();
			_gameField.init();*/
			
			_fabi = new FabiQuiz();
			_fabi.view = new FabiView();
			_fabi.view.x = 80;
			_fabi.view.y = 300;
			_fabi.init();
			view._chichenItzaContainer.addChild( _fabi.view );
			
			const quizOptions : FabisQuizGameOptions = new FabisQuizGameOptions();
			/*wordsCaptureOptions.catched = new Vector.<KolosseumStone>();
			wordsCaptureOptions.allPics = new Vector.<KolosseumStone>();
			wordsCaptureOptions.wrongStones = new Vector.<KolosseumStone>();
			wordsCaptureOptions.rightStones = new Vector.<KolosseumStone>();
			wordsCaptureOptions.background = view._kolosseum;*/
			quizOptions.fabi = _fabi;
			quizOptions.view = view;
			
			_game = new FabisQuizGame();
			_game.initWithOptions( quizOptions );
			
			/*view._gameFieldContainer.addChild( _gameField.gameField );*/
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
