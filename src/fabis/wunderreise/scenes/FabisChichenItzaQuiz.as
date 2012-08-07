package fabis.wunderreise.scenes {
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.quiz.FabisChichenItzaQuizGame;
	import fabis.wunderreise.games.quiz.FabiQuiz;
	import fabis.wunderreise.games.quiz.FabisQuizGameOptions;
	import fabis.wunderreise.games.quiz.FabisQuizGame;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChichenItzaQuiz extends BaseScene {
		
		protected var _game : FabisChichenItzaQuizGame;
		protected var _fabi : FabiQuiz;
		protected var _skipButton : FabisSkipButton;
		
		public function FabisChichenItzaQuiz() {
			super();
		}

		private function get view() : FabisChichenItzaView {
			return FabisChichenItzaView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisChichenItzaView();
			
			_fabi = new FabiQuiz();
			_fabi.view = new FabiView();
			_fabi.view.x = 80;
			_fabi.view.y = 300;
			_fabi.init();
			view._chichenItzaContainer.addChild( _fabi.view );
			
			const quizOptions : FabisQuizGameOptions = new FabisQuizGameOptions();
			quizOptions.fabi = _fabi;
			quizOptions.view = view;
			quizOptions.switchTime = 20;
			quizOptions.questionNumber = 3;
			
			// right answers of questions -> 0 for false, 1 for true
			quizOptions.answers = new Array( 0, 1, 1);
			quizOptions.trueButtonStartTime = 27;
			
			
			_game = new FabisChichenItzaQuizGame();
			_game.initWithOptions( quizOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			quizOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view._chichenItzaContainer.addChild( _skipButton );
			
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
