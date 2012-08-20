package fabis.wunderreise.games.wordsCapture.kolosseum {
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	
	/**
	 * @author Stefanie Drost
	 */
	public class KolosseumGame extends FabisWordsCaptureGame{
		
		protected var _gameField : KolosseumGameField;
		protected var _stone : KolosseumStone;
		protected var _fabi : FabiView;
		
		public function KolosseumGame() {
			
		}
		
		override public function initWithOptions( options : FabisWordsCaptureGameOptions ) : void {
			_gameOptions = options;
			_gameField = KolosseumGameField( _gameOptions.gameField );
			
			//number of frames in mc
			_gameOptions.wrongPics = new Array( 1, 2, 3 );
			_gameOptions.rightPics = new Array( 4, 5, 6, 7, 8 );
			_gameOptions.feedbackOrder = new Array( 8, 7, 4, 6, 5 );
			// time in seconds
			_gameOptions.feedbackTimes = new Array( 11, 16, 26, 36, 41, 50 );
			
			// coordinates for adding stones
			_gameOptions.wallXCoordinates = new Array( 451, 385, 323, 264, 227 );
			_gameOptions.wallYCoordinates = new Array( 26, 36, 44, 56, 72 );
			
			_gameOptions.frameArray = _gameOptions.initFrameArray();
			_gameField._gameOptions = _gameOptions;
			
			_fabi = _gameOptions.fabi;
			_fabi.x = 90;
			_fabi.y = 295;
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._arm.gotoAndStop( 1 );
			
			_gameOptions.eyeTwinkler.initWithEyes( _fabi._eyes );
		}
		
		override public function skipIntro( event : MouseEvent ) : void {
			_gameField.skipIntro();
			_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
		}
		
		override public function start() : void {
			_gameField.soundCore = soundCore;
			_gameField.gameCore = gameCore;
			_gameField.startIntro();
		}
		
		override public function stop() : void {
			_gameField.stop();
		}
	}
}
