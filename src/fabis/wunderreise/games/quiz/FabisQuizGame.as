package fabis.wunderreise.games.quiz {
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizGame extends Sprite {
		
		protected var _view : FabisCloseView;
		protected var _gameOptions : FabisQuizGameOptions;
		protected var _soundManager : FabisQuizSoundManager;
		protected var _imageContainer : FabisQuizImageContainer;
		protected var _fabiClose : FabiQuizClose;
		
		public function FabisQuizGame() {
			
		}
		
		private function get view() : FabisCloseView {
			return FabisCloseView( _view );
		}
		
		public function initWithOptions( options : FabisQuizGameOptions ) : void {
			_gameOptions = options;
			
			_view = new FabisCloseView();
			_fabiClose = new FabiQuizClose();
			_fabiClose._fabi = view._closeContainer._fabiClose;
			_fabiClose.init();
			
			_soundManager = new FabisQuizSoundManager();
			_soundManager.initWithOptions( _gameOptions );
			_soundManager._game = this;
		}
		
		public function start() : void {
			startIntro();
		}
		
		public function stop() : void {
			//_gameField.stop();
		}
		
		public function switchToCloseView() : void {
			_gameOptions.view.removeChild( _gameOptions.view._chichenItzaContainer );
			_gameOptions.view.addChild( view._closeContainer );
			//_view = new FabisCloseView();
		}
		
		public function startIntro() : void {
			_soundManager.playIntro();
		}
		
		public function startGame() : void {
			switchToCloseView();
			initImageContainer();
			_fabiClose.initNose();
		}
		
		public function initImageContainer() : void {
			_imageContainer = new FabisQuizImageContainer();
			_imageContainer.x = 380;
			_imageContainer.y = 90;
			_imageContainer.gotoAndStop( 1 );
			view._closeContainer.addChild( _imageContainer );
		}
	}
}
