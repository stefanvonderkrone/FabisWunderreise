package fabis.wunderreise.games.wordsCapture.petra {
	import com.junkbyte.console.Cc;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	/**
	 * @author Stefanie Drost
	 */
	public class PetraGame extends FabisWordsCaptureGame {
		
		protected var _gameField : PetraGameField;
		protected var _stone : PetraStone;
		protected var _fabi : FabiView;
		
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
			_gameField.startIntro();
		}
		
		override public function stop() : void {
			Cc.logch.apply( undefined, [ "stop in Petra "] );
			super.stop();
		}
	}
}
