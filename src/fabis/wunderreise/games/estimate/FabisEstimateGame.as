package fabis.wunderreise.games.estimate {
	import flash.display.MovieClip;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import fabis.wunderreise.sound.IFabisLipSyncherDelegate;
	import flash.events.MouseEvent;
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
	public class FabisEstimateGame extends Sprite implements ISoundItemDelegate, IFabisLipSyncherDelegate {
		
		public var _gameOptions : FabisEstimateGameOptions;
		
		protected var _mainView : FabisCristoView;
		protected var _fabiCristo : FabiCristo;
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
		
		protected var _smallView : Boolean = true;
		
		public function FabisEstimateGame() {
			
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
		}
		
		public function skipIntro( event : MouseEvent ) : void {
			_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
			_introSound.stop();
			_introSoundStarted = false;
			_mainView.removeChild( _gameOptions.fabiCristoSmallContainer );
			initFabi();
		}
		
		public function initFabi() : void {
			_smallView = false;
			_fabiCristo = new FabiCristo();
			_fabiCristo._fabi._lips.gotoAndStop( 1 );
			_fabiCristo._fabi._eyes.gotoAndStop( 1 );
			_fabiCristo._fabi._nose.gotoAndStop( 1 );
			_fabiCristo._fabi._arm.gotoAndStop( 1 );
			//_fabi.init();
			_gameOptions.fabiCristo = _fabiCristo;
			_gameOptions.fabiCristoContainer.addChild( _fabiCristo );
			
			_gameOptions.eyeTwinkler.initWithEyes(_fabiCristo._fabi._eyes );
			
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
			_gameOptions.lipSyncher.start();
			//_fabi.startSynchronization();
			_gameOptions.fabiCristo.addEventListener( Event.ENTER_FRAME, _currentExercise.handleGameInstructions );
		}
		
		public function start() : void {
			//TODO: add intro
			startIntro();
		}
		
		public function stop() : void {
			//super.stop();
		}
		
		public function initDrag() : void {
			_currentExercise.initDrag();
		}
		
		public function startIntro() : void {
			_gameOptions.lipSyncher.delegate = this;
			
			_introSound = _soundCore.getSoundByName( "cristoIntro" );
			_introSoundStarted = true;
			_introSound.delegate = this;
			_introSound.play();
			
			_gameOptions.lipSyncher.start();
			//_gameOptions.fabiSmall.startSynchronization();
			_gameOptions.fabiSmall.addEventListener( Event.ENTER_FRAME, handleFlip );
		}
		
		private function handleFlip( event : Event ) : void {
			
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.flipTime * 60 ){
				_gameOptions.fabiSmall.removeEventListener( Event.ENTER_FRAME, handleFlip );
				_gameOptions.lipSyncher.stop();
				//_gameOptions.fabiSmall.stopSynchronization();
				TweenLite.to( _gameOptions.fabiSmall._fabi._arm, 1/2, {frame: _gameOptions.fabiSmall._fabi._arm.totalFrames} );
				TweenLite.delayedCall( 1, _mainView.removeChild, [ _gameOptions.fabiCristoSmallContainer ] );
				_frameCounter = 0;
			}
		}
		
		public function endOfExercise() : void {
			_gameOptions.lipSyncher.stop();
			//_fabi.stopSynchronization();
			
			if( _secondTry ){
				_currentExercise.reset();
				_gameOptions.lipSyncher.start();
				//_fabi.startSynchronization();
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
				_gameOptions.lipSyncher.stop();
				//_fabi.stopSynchronization();
				_exerciseSoundStarted = false;
				TweenLite.delayedCall(1, initDrag);
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

		public function reactOnCumulatedSpectrum(cumulatedSpectrum : Number) : void {
			var lips : MovieClip;
			if( _smallView )
				lips = _gameOptions.fabiSmall._fabi._lips;
			else 
				lips = _gameOptions.fabiCristo._fabi._lips;
				
				
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}

		public function reactOnStart(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnStop(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnDisposal(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnAddedToDelegater(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnRemovalFromDelegater(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnGameFinished(result : Object, gameCore : IGameCore) : void {
		}

		public function get gameCore() : IGameCore {
			return null;
		}

		public function set gameCore(gameCore : IGameCore) : void {
		}
		
		public function flip() : void {
			TweenLite.to( _fabiCristo._fabi._arm, 1, {frame: _fabiCristo._fabi._arm.totalFrames} );
			TweenLite.delayedCall(1, _fabiCristo._fabi._arm.gotoAndStop, [1] );
		}
	}
}
