package fabis.wunderreise.scenes {
	import fabis.wunderreise.sound.FabisLipSyncher;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.quiz.FabisChineseWallQuizGame;
	import fabis.wunderreise.games.quiz.FabisQuizGameOptions;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChineseWallQuiz extends BaseScene {
		
		protected var _game : FabisChineseWallQuizGame;
		protected var _fabi : FabiView;
		protected var _skipButton : FabisSkipButton;
		protected var _lipSyncher : FabisLipSyncher;
		
		public function FabisChineseWallQuiz() {
			super();
		}

		private function get view() : FabisChineseWallView {
			return FabisChineseWallView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisChineseWallView();
						
			_fabi = new FabiView();
			_fabi.x = 80;
			_fabi.y = 300;
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._arm.gotoAndStop( 1 );
			view._chineseWallContainer.addChild( _fabi );
			
			const quizOptions : FabisQuizGameOptions = new FabisQuizGameOptions();
			quizOptions.fabi = _fabi;
			quizOptions.view = view;
			quizOptions.switchTime = 26;
			quizOptions.questionNumber = 3;
			
			// right answers of questions -> 0 for false, 1 for true
			quizOptions.answers = new Array( 0, 1, 0);
			quizOptions.trueButtonStartTime = 33;
			
			_lipSyncher = new FabisLipSyncher();
			quizOptions.lipSyncher = _lipSyncher;
			
			_game = new FabisChineseWallQuizGame();
			_game.initWithOptions( quizOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			quizOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view._chineseWallContainer.addChild( _skipButton );
			
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_game.soundCore = gameCore.soundCore;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
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
