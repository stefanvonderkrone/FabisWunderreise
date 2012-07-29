package fabis.wunderreise.games.wordsCapture.petra {
	import fabis.wunderreise.games.wordsCapture.FabiWordsCapture;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	/**
	 * @author Stefanie Drost
	 */
	public class PetraGame extends FabisWordsCaptureGame {
		
		protected var _gameField : PetraGameField;
		protected var _stone : PetraStone;
		protected var _fabi : FabiWordsCapture;
		
		public function PetraGame() {
			
		}
		
		override public function initWithOptions( options : FabisWordsCaptureGameOptions ) : void {
			_gameOptions = options;
			_gameField = PetraGameField( _gameOptions.gameField );
			
			//number of frames in mc
			_gameOptions.wrongPics = new Array( 6, 7, 8 );
			_gameOptions.rightPics = new Array( 1, 2, 3, 4, 5 );
			_gameOptions.feedbackOrder = new Array( 2, 3, 5 );
			// time in seconds
			_gameOptions.feedbackTimes = new Array( 13, 25, 32 );
			
			// coordinates for adding stones
			_gameOptions.wallXCoordinates = new Array( 158, 190, 220, 250, 280 );
			_gameOptions.wallYCoordinates = new Array( 90, 85, 75, 60, 65 );
			
			_gameOptions.frameArray = _gameOptions.initFrameArray();
			_gameField._gameOptions = _gameOptions;
			
			_gameOptions.soundManager = new PetraSoundManager();
			_gameOptions.soundManager.initWithOptions( _gameOptions );
			
			_fabi = _gameOptions.fabi;
			
		}
		
		override public function start() : void {
			_gameField.startIntro();
			//_gameField.start();
			//_fabi.startSynchronization();
		}
		
		override public function stop() : void {
			_gameField.stop();
		}
	}
}
