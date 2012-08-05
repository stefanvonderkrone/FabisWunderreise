package fabis.wunderreise.games.estimate {
	import com.greensock.TweenLite;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import flash.events.ProgressEvent;

	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.events.ErrorEvent;
	import flash.events.SampleDataEvent;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGame extends Sprite implements ISoundItemDelegate {
		
		public var _gameOptions : FabisEstimateGameOptions;
		
		protected var _mainView : FabisCristoView;
		protected var _fabi : FabiEstimate;
		//TODO: change to 1
		protected var _currentExerciseNumber : int = 1;
		protected var _secondTry : Boolean = false;
		public var _currentExercise : *;
		
		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		
		protected var _exerciseSound : ISoundItem;
		protected var _exerciseSoundStarted : Boolean = false;
		
		protected var _soundCore : ISoundCore;
		protected var _frameCounter : int = 0;
		
		public function FabisEstimateGame() {
			
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
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
			_gameOptions.currentExerciseNumber = exerciseNumber;
			
			switch( exerciseNumber ){
				case 1 :
					_currentExercise = new FabisEstimateGiraffesExercise();
					_exerciseSound = _soundCore.getSoundByName( "cristoGiraffesExercise" );
					_currentExercise.initWithOptions( _gameOptions );
					break;
				case 2 :
					_currentExercise = new FabisEstimateCarsExercise();
					_exerciseSound = _soundCore.getSoundByName( "cristoCarsExercise" );
					_currentExercise.initWithOptions( _gameOptions );
					break;
			}
			_currentExercise._game = this;
			_currentExercise.soundCore = soundCore;
			_exerciseSound.delegate = this;
			_exerciseSound.play();
			_exerciseSoundStarted = true;
			_fabi.startSynchronization();
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, _currentExercise.handleGameInstructions );
		}
		
		public function start() : void {
			//TODO: add intro
			//startIntro();
			_mainView.removeChild( _gameOptions.fabiCristoSmallContainer );
			initFabi();
		}
		
		public function stop() : void {
			//super.stop();
		}
		
		public function initDrag() : void {
			_currentExercise.initDrag();
		}
		
		public function startIntro() : void {
			_introSound = _soundCore.getSoundByName( "cristoIntro" );
			_introSoundStarted = true;
			_introSound.delegate = this;
			_introSound.play();
			_gameOptions.fabiSmall.startSynchronization();
			_gameOptions.fabiSmall.addEventListener( Event.ENTER_FRAME, handleFlip );
		}
		
		private function handleFlip( event : Event ) : void {
			
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.flipTime * 60 ){
				_gameOptions.fabiSmall.removeEventListener( Event.ENTER_FRAME, handleFlip );
				_gameOptions.fabiSmall.stopSynchronization();
				TweenLite.to( _gameOptions.fabiSmall.view, 1/2, {frame: _gameOptions.fabiSmall.view.totalFrames} );
				TweenLite.delayedCall( 1, _mainView.removeChild, [ _gameOptions.fabiCristoSmallContainer ] );
				_frameCounter = 0;
			}
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
		

		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				initFabi();
			}
			if( _exerciseSoundStarted ){
				_fabi.stopSynchronization();
				_exerciseSoundStarted = false;
				initDrag();
			}
			
		}

		public function reactOnSoundItemLoadComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemErrorEvent(evt : ErrorEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSampleDataEvent(evt : SampleDataEvent, soundItem : ISoundItem) : void {
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
		
		public function set soundCore( soundCore : ISoundCore) : void {
			_soundCore = soundCore;
		}
		
		public function get soundCore() : ISoundCore {
			return _soundCore;
		}
	}
}
