package fabis.wunderreise.scenes {
	
	import fabis.wunderreise.games.quiz.FabisChineseWallQuizGame;
	import fabis.wunderreise.games.quiz.FabiQuiz;
	import fabis.wunderreise.games.quiz.FabisQuizGameOptions;
	import fabis.wunderreise.games.quiz.FabisQuizGame;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChineseWallQuiz extends BaseScene {
		
		protected var _game : FabisQuizGame;
		protected var _fabi : FabiQuiz;
		
		public function FabisChineseWallQuiz() {
			super();
		}

		private function get view() : FabisChineseWallView {
			return FabisChineseWallView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisChineseWallView();
			_fabi = new FabiQuiz();
			_fabi.view = new FabiView();
			_fabi.view.x = 80;
			_fabi.view.y = 300;
			_fabi.init();
			view._chineseWallContainer.addChild( _fabi.view );
			
			const quizOptions : FabisQuizGameOptions = new FabisQuizGameOptions();
			quizOptions.fabi = _fabi;
			quizOptions.view = view;
			quizOptions.switchTime = 26;
			quizOptions.questionNumber = 3;
			
			// right answers of questions -> 0 for false, 1 for true
			quizOptions.answers = new Array( 0, 1, 0);
			quizOptions.trueButtonStartTime = 33;
			
			_game = new FabisChineseWallQuizGame();
			_game.initWithOptions( quizOptions );
			
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
