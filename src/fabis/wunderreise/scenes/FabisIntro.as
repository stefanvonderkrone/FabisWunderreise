package fabis.wunderreise.scenes {

	import flash.display.MovieClip;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisIntro extends BaseScene implements ISoundItemDelegate {
		
		protected static const UPDATE_FRAMES : int = 5;

		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		protected var _numFrames : int = 0;
		protected var _spectrumFloat : Number = 0;
		protected var _spectrum : ByteArray;

		public function FabisIntro() {
			super();
		}
		
		private function get view() : FabisIntroView {
			return FabisIntroView( _view );
		}

		override protected function handleCreation() : void {
			_view = new FabisIntroView();
			view._fabi._lips.gotoAndStop( 1 );
			_spectrum = new ByteArray();
			super.handleCreation();
		}

		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_introSound = gameCore.soundCore.getSoundByName( "menuIntro" );
			_introSound.delegate = this;
		}

		override protected function handleStart() : void {
			super.handleStart();
			TweenLite.from(
				view._fabi,
				1, {
					x: -view._fabi.width,
					onComplete: startSound
				}
			);
		}
		
		protected function startSound() : void {
			_introSound.play();
			_introSoundStarted = true;
		}

		override protected function handleStop() : void {
			super.handleStop();
			_introSound.stop();
			TweenLite.killDelayedCallsTo( gameCore.director.replaceScene );
			TweenLite.killTweensOf( view._fabi );
		}

		override protected function handleDisposal() : void {
			super.handleDisposal();
			_introSound.delegate = null;
			_introSound = null;
			_spectrum = null;
		}
		
		override public function update( deltaTime : Number ) : void {
			deltaTime;
			if ( _introSoundStarted ) {
				_numFrames++;
				SoundMixer.computeSpectrum( _spectrum, false, 0 );
				for (var i:int = 0; i < 512; i++) {
					_spectrumFloat += Math.abs( _spectrum.readFloat() );
				}
				if ( _numFrames == UPDATE_FRAMES ) {
					const lips : MovieClip = view._fabi._lips;
					if ( _spectrumFloat > 30 ) {
						lips.gotoAndStop(
							int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
						);
					} else lips.gotoAndStop( 1 );
					_spectrumFloat = 0;
					_numFrames = 0;
				}
			}
			super.update(deltaTime);
//			if ( gameCore.keyboardHandler.isKeyPressed( "c" ) ) {
//				_introSound.stop();
//				gameCore.director.replaceScene( new FabisMainMenu(), true );
//			}
		}

		public function reactOnSoundItemProgressEvent( evt : ProgressEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemEvent( evt : Event, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemSoundComplete( soundItem : ISoundItem ) : void {
			TweenLite.delayedCall(
				0.5,
				gameCore.director.replaceScene,
				[ new FabisMainMenu(), true ]
			);
		}

		public function reactOnSoundItemLoadComplete( soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemErrorEvent( evt : ErrorEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemSampleDataEvent( evt : SampleDataEvent, soundItem : ISoundItem ) : void {
		}
	}
}
