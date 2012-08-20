package fabis.wunderreise.scenes {
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
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
		
		protected var _game : PetraGame;
		protected var _gameField : PetraGameField;
		protected var _fabiView : FabiView;
		protected var _skipButton : FabisSkipButton;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		
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
			
			const wordsCaptureOptions : FabisWordsCaptureGameOptions = new FabisWordsCaptureGameOptions();
			wordsCaptureOptions.catched = new Vector.<PetraStone>();
			wordsCaptureOptions.allPics = new Vector.<PetraStone>();
			wordsCaptureOptions.wrongStones = new Vector.<PetraStone>();
			wordsCaptureOptions.rightStones = new Vector.<PetraStone>();
			//wordsCaptureOptions.background = view._petra;
			wordsCaptureOptions.fabi = new FabiView();
			wordsCaptureOptions.gameField = _gameField;
			wordsCaptureOptions.demoStartTime = 10;
			
			_lipSyncher = new FabisLipSyncher();
			wordsCaptureOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			//_eyeTwinkler.initWithEyes( _fabi._eyes );
			wordsCaptureOptions.eyeTwinkler = _eyeTwinkler;
			
			_game = new PetraGame();
			_game.initWithOptions( wordsCaptureOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			wordsCaptureOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view.addChild( _skipButton );
			
			view._gameFieldContainer.addChild( _gameField.gameField );
			view.addChild( wordsCaptureOptions.fabi );
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
			_game.stop();
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
