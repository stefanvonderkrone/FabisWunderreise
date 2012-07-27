package fabis.wunderreise.games.wordsCapture.kolosseum {
	
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameOptions;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGame;
	
	/**
	 * @author Stefanie Drost
	 */
	public class KolosseumGame extends FabisWordsCaptureGame{
		
		protected var _gameField : KolosseumGameField;
		protected var _stone : KolosseumStone;
		//protected var _view : FabisKolosseumView;
		
		public function KolosseumGame() {
			
		}
		
		override public function initWithOptions( options : FabisWordsCaptureGameOptions ) : void {
			_gameOptions = options;
			_gameField = KolosseumGameField( _gameOptions.gameField );
			
			_gameOptions.wrongPics = new Array( 1, 2, 3 );
			_gameOptions.rightPics = new Array( 4, 5, 6, 7, 8 );
			_gameOptions.feedbackOrder = new Array( 8, 7, 4, 6, 5 );
			_gameOptions.feedbackTimes = new Array( 11, 16, 26, 36, 41, 50 );
			
			_gameOptions.frameArray = _gameOptions.initFrameArray();
			_gameField._gameOptions = _gameOptions;
			
			_gameOptions.soundManager = new KolosseumSoundManager();
			_gameOptions.soundManager.initWithOptions( _gameOptions );
			
		}
		
		override public function start() : void {
			_gameField.startIntro();
			//_gameField.start();
		}
		
		override public function stop() : void {
			_gameField.stop();
		}
	}
}
