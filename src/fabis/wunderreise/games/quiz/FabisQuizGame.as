package fabis.wunderreise.games.quiz {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizGame extends Sprite {
		
		protected var _view : FabisCloseView;
		protected var _gameOptions : FabisQuizGameOptions;
		protected var _soundManager : FabisQuizSoundManager;
		
		public function FabisQuizGame() {
			
		}
		
		private function get view() : FabisCloseView {
			return FabisCloseView( _view );
		}
		
		public function initWithOptions( options : FabisQuizGameOptions ) : void {
			_gameOptions = options;
			
			_view = new FabisCloseView();
			_soundManager = new FabisQuizSoundManager();
			_soundManager.initWithOptions( _gameOptions );
		}
		
		public function start() : void {
			startIntro();
			//_gameField.start();
			//_fabi.startSynchronization();
		}
		
		public function stop() : void {
			//_gameField.stop();
		}
		
		public function switchToCloseView() : void {
			_gameOptions.view.removeChild( _gameOptions.view._chichenItzaContainer );
			_gameOptions.view.addChild( view );
			//_view = new FabisCloseView();
		}
		
		public function startIntro() : void {
			_soundManager.playIntro();
		}
	}
}
