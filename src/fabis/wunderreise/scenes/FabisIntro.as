package fabis.wunderreise.scenes {

	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import fabis.wunderreise.sound.IFabisLipSyncherDelegate;

	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisIntro extends BaseScene implements ISoundItemDelegate, IFabisLipSyncherDelegate {
		
		protected static const UPDATE_FRAMES : int = 5;

		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;

		public function FabisIntro() {
			super();
		}
		
		private function get view() : FabisIntroView {
			return FabisIntroView( _view );
		}

		override protected function handleCreation() : void {
			_view = new FabisIntroView();
			view._fabi._lips.gotoAndStop( 1 );
			view._fabi._eyes.gotoAndStop( 1 );
			_lipSyncher = new FabisLipSyncher();
			_lipSyncher.delegate = this;
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( view._fabi._eyes );
			super.handleCreation();
		}

		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_introSound = gameCore.soundCore.getSoundByName( "menuIntro" );
			_introSound.delegate = this;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
			_eyeTwinkler.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _eyeTwinkler );
		}

		override protected function handleStart() : void {
			super.handleStart();
			_eyeTwinkler.start();
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
			_lipSyncher.start();
		}

		override protected function handleStop() : void {
			super.handleStop();
			_introSound.stop();
			TweenLite.killDelayedCallsTo( gameCore.director.replaceScene );
			TweenLite.killTweensOf( view._fabi );
			_lipSyncher.stop();
			_eyeTwinkler.stop();
		}

		override protected function handleDisposal() : void {
			super.handleDisposal();
			_introSound.delegate = null;
			_introSound = null;
			_lipSyncher.gameCore = null;
			_lipSyncher.dispose();
			_eyeTwinkler.gameCore = null;
			_eyeTwinkler.dispose();
		}
		

		public function reactOnSoundItemSoundComplete( soundItem : ISoundItem ) : void {
			TweenLite.delayedCall(
				0.5,
				gameCore.director.replaceScene,
				[ new FabisMainMenu(), true ]
			);
		}

		public function reactOnCumulatedSpectrum( cumulatedSpectrum : Number ) : void {
			const lips : MovieClip = view._fabi._lips;
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}

		public function reactOnSoundItemProgressEvent( evt : ProgressEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemEvent( evt : Event, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemLoadComplete( soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemErrorEvent( evt : ErrorEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemSampleDataEvent( evt : SampleDataEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnStart( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnStop( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnDisposal( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnAddedToDelegater( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnRemovalFromDelegater( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnGameFinished( result : Object, gameCore : IGameCore ) : void {
		}
	}
}
