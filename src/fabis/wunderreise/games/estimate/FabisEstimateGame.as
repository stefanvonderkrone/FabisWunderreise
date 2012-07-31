package fabis.wunderreise.games.estimate {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGame extends Sprite {
		
		protected var _mainView : FabisCristoView;
		protected var _gameOptions : FabisEstimateGameOptions;
		protected var _soundManager : FabisEstimateSoundManager;
		protected var _fabi : FabiEstimate;
		protected var _currentExerciseNumber : int = 1;
		protected var _giraffesDragContainer : CristoGiraffesDragContainer;
		protected var _stackField : CristoStackField;
		protected var _doneButton : DoneButton;
		
		public function FabisEstimateGame() {
			
		}
		
		
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			
			_soundManager = new FabisEstimateSoundManager();
			_soundManager.initWithOptions( _gameOptions );
			_soundManager._game = this;
			
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
		}
		
		public function initFabi() : void {
			_fabi = new FabiEstimate();
			_fabi.init();
			_gameOptions.fabi = _fabi;
			_gameOptions.fabiCristoContainer.addChild( _fabi.view );
			
			startExercise( _currentExerciseNumber );
		}
		
		public function startExercise( exerciseNumber : int ) : void {
			_fabi.startSynchronization();
			_soundManager.playExercise( exerciseNumber );
		}
		
		public function removeStatue() : void {
			var _cristo : MovieClip = _mainView._cristo;
			_gameOptions.fabiCristoContainer.parent.removeChild( _cristo );
		}
		
		public function initGiraffes() : void {
			
			var _i : int;
			var _y : int = -50;
			var _x : int = 0;
			var _giraffe : CristoGiraffeView;
			
			initGiraffesContainer();
			
			for( _i = 0; _i < 10; _i++ ){
				_giraffe = new CristoGiraffeView();
				_giraffe.width = 50;
				_giraffe.height = 76;
				
				if( _i % 2 == 0 ){
					_y += 78;
					_x = 0;
				}
				else{
					_x += 70;
				}
				_giraffe.x = _x;
				_giraffe.y = _y;
				
				_giraffesDragContainer.addChild( _giraffe );
			}
		}
		
		private function initGiraffesContainer() : void {
			
			_giraffesDragContainer = new CristoGiraffesDragContainer();
			_giraffesDragContainer.x = 750;
			_giraffesDragContainer.y = 0;
			
			_gameOptions.cristoGiraffesDragContainer = _giraffesDragContainer;
			_mainView.addChild( _giraffesDragContainer );
		}
		
		public function initGiraffesSockel() : void {
			var _giraffesSockel : CristoGiraffesSockel = new CristoGiraffesSockel();
			_giraffesSockel.x = 505;
			_giraffesSockel.y = 405;
			_mainView.addChild( _giraffesSockel );
			initStackField();
		}
		
		private function initStackField() : void {
			_stackField = new CristoStackField();
			_stackField.x = 500;
			_stackField.y = 11;
			_mainView.addChild( _stackField );
		}
		
		public function initDoneButton() : void {
			_doneButton = new DoneButton();
			_doneButton.x = 725;
			_doneButton.y = 450;
			_mainView.addChild( _doneButton );
		}
		
		public function start() : void {
			//TODO: add intro
			//startIntro();
			_mainView.removeChild( _gameOptions.fabiCristoSmallContainer );
			initFabi();
		}
		
		public function stop() : void {
			//_gameField.stop();
		}
		
		
		public function startIntro() : void {
			_soundManager.playIntro();
		}
	}
}
