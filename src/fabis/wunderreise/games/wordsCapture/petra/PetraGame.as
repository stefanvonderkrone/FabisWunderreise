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
			_gameOptions.wrongPics = [ 6, 7, 8 ];
			_gameOptions.rightPics = [ 1, 2, 3, 4, 5 ];
			_gameOptions.feedbackOrder = [ 1, 2, 3, 5, 4 ];
			// time in seconds
			_gameOptions.feedbackTimes = [ 8, 13, 25, 32, 48, 55 ];
			
			// coordinates for adding stones
			_gameOptions.wallXCoordinates = [ 320, 390, 440, 500, 560 ];
			_gameOptions.wallYCoordinates = [ 20, 20, 23, 21, 21 ];
			
			_gameOptions.frameArray = _gameOptions.initFrameArray();
			_gameField._gameOptions = _gameOptions;
			
			_fabi = _gameOptions.fabi;
			_fabi.x = 50;
			_fabi.y = 295;
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._arm.gotoAndStop( 1 );
			
			_gameOptions.eyeTwinkler.initWithEyes( _fabi._eyes );
		}
		
		override public function skipIntro( event : MouseEvent ) : void {
			_gameField.skipIntro();
			_fabi._lips.gotoAndStop( 1 );
			_gameOptions.skipButton.parent.removeChild( _gameOptions.skipButton );
			_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
		}
		
		override public function start() : void {
			_gameField.soundCore = soundCore;
			_gameField.gameCore = gameCore;
			_gameField.startIntro();
		}
		
		override public function stop() : void {
			Cc.logch.apply( undefined, [ "stop in Petra "] );
			super.stop();
		}
		
		override public function hasCurrentSound() : Boolean {
			if( _gameField._introSoundStarted || _gameField._feedbackSoundStarted || _gameField._pointsSoundStarted
				|| _gameField._completionSoundStarted ){
				return true;
			}
			return false;
		}
	}
}
