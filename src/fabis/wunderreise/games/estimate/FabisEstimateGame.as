package fabis.wunderreise.games.estimate {
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGame extends Sprite {
		
		protected var _mainView : FabisCristoView;
		public var _gameOptions : FabisEstimateGameOptions;
		protected var _soundManager : FabisEstimateSoundManager;
		protected var _fabi : FabiEstimate;
		protected var _currentExerciseNumber : int = 1;
		protected var _secondTry : Boolean = false;
		
		protected var _currentExercise : *;
		
		public function FabisEstimateGame() {
			
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
			
			//_gameOptions.giraffesGame = new FabisEstimateGiraffesGame();
			
			_soundManager = new FabisEstimateSoundManager();
			_soundManager.initWithOptions( _gameOptions );
			_soundManager._game = this;
			_gameOptions.soundManager = _soundManager;
		}
		
		public function initFabi() : void {
			_fabi = new FabiEstimate();
			_fabi.init();
			_gameOptions.fabi = _fabi;
			_gameOptions.fabiCristoContainer.addChild( _fabi.view );
			
			startExercise( _currentExerciseNumber );
		}
		
		public function startExercise( exerciseNumber : int ) : void {
			
			switch( exerciseNumber ){
				case 1 :
					_currentExercise = new FabisEstimateGiraffesExercise();
					_currentExercise.initWithOptions( _gameOptions );
					break;
				case 2 :
					_currentExercise = new FabisEstimateCarsExercise();
					_currentExercise.initWithOptions( _gameOptions );
					break;
			}
			
			_fabi.startSynchronization();
			_soundManager.playExercise( exerciseNumber );
		}
		
		public function start() : void {
			//TODO: add intro
			startIntro();
			//_mainView.removeChild( _gameOptions.fabiCristoSmallContainer );
			//initFabi();
		}
		
		public function stop() : void {
			//super.stop();
		}
		
		public function initDrag() : void {
			_currentExercise.initDrag();
		}
		
		public function startIntro() : void {
			_soundManager.playIntro();
		}
		
		
		
		public function endOfExercise() : void {
			
			_fabi.stopSynchronization();
			
			if( _secondTry ){
				_currentExercise.reset();
				_fabi.startSynchronization();
			}
			else{
				_currentExercise.clean();
				_currentExerciseNumber++;
				if( _currentExerciseNumber <= _gameOptions.exerciseNumber ){
					startExercise( _currentExerciseNumber );
				}
				else{
					stop();
				}
			}
			
		}
		
		public function get giraffesGame() : FabisEstimateGiraffesExercise {
			return FabisEstimateGiraffesExercise( _currentExercise );
		}
		
		public function get carsGame() : FabisEstimateCarsExercise {
			return FabisEstimateCarsExercise( _currentExercise );
		}
		
		public function set secondTry( secondTry : Boolean) : void {
			_secondTry = secondTry;
		}
	}
}
