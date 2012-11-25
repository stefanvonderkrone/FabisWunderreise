package fabis.wunderreise.games.wordsCapture.kolosseum {
	import com.junkbyte.console.Cc;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	
	/**
	 * @author Stefanie Drost
	 */
	public class KolosseumGame extends FabisWordsCaptureGame{
		
		public var _gameField : KolosseumGameField;
		protected var _stone : KolosseumStone;
		protected var _fabi : FabiView;
		
		public function KolosseumGame() {
			
		}
		
		override public function initWithOptions( options : FabisWordsCaptureGameOptions ) : void {
			_gameOptions = options;
			_gameField = KolosseumGameField( _gameOptions.gameField );
			
			//number of frames in mc
			_gameOptions.wrongPics = [ 1, 2, 3 ];
			_gameOptions.rightPics = [ 4, 5, 6, 7, 8 ];
			_gameOptions.feedbackOrder = [ 8, 7, 4, 6, 5 ];
			// time in seconds
			_gameOptions.feedbackTimes = [ 11, 16, 26, 33, 41, 50 ];
			
			// coordinates for adding stones
			_gameOptions.wallXCoordinates = [ 451, 385, 323, 264, 227 ];
			_gameOptions.wallYCoordinates = [ 26, 36, 44, 56, 72 ];
			
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
			Cc.logch.apply( undefined, [ "stop in KolosseumGame "] );
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
