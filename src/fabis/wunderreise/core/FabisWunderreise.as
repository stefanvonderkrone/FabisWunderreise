package fabis.wunderreise.core {
	import fabis.wunderreise.scenes.FabisCristoEstimate;
	import com.greensock.plugins.ScalePlugin;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.LoaderMax;
	import com.flashmastery.as3.game.core.sound.SoundCore;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import fabis.wunderreise.scenes.FabisMainMenu;

	import com.flashmastery.as3.game.core.FlashGraphicsCore;
	import com.flashmastery.as3.game.core.GameCore;
	import com.flashmastery.as3.game.core.KeyboardHandler;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.delegates.IGameDelegate;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.junkbyte.console.Cc;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class FabisWunderreise extends Sprite implements IGameDelegate {

		private var _gameCore : IGameCore;
		private static const _debugging : Boolean = true;

		public function FabisWunderreise() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}

		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			TweenPlugin.activate( [ FramePlugin, ColorTransformPlugin, ScalePlugin ] );
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			if ( _debugging ) {
				Cc.startOnStage( stage, "fabi" );
				Cc.config.tracing = true;
				Cc.listenUncaughtErrors( loaderInfo );
				//Cc.visible = true;
			}
			_gameCore = new GameCore();
			_gameCore.delegate = this;
			_gameCore.autoSetupOnStageReceived();
			_gameCore.setupWithStage( stage );
			_gameCore.setupWithGraphicsCore( new FlashGraphicsCore() );
			_gameCore.setupWithKeyboardHandler( new KeyboardHandler() );
			_gameCore.setupWithSoundCore( getSoundCore() );
			_gameCore.director.runWithScene( new FabisMainMenu() );
			_gameCore.graphicsCore.setSize( stage.stageWidth, stage.stageHeight );
			_gameCore.start();
			_gameCore.soundCore.getSoundByName( "atmo" ).play( 0, int.MAX_VALUE );
		}

		protected function getSoundCore() : ISoundCore {
			const soundCore : SoundCore = new SoundCore();
			const soundsLoaderMax : LoaderMax = LoaderMax.getLoader( "FabisSounds" );
			var numSounds : int = soundsLoaderMax.numChildren;
			var mp3Loader : MP3Loader;
			while ( --numSounds >= 0 ) {
				mp3Loader = soundsLoaderMax.getChildAt( numSounds );
				soundCore.registerSound( mp3Loader.name, mp3Loader.content );
			}
			return soundCore;
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

		public function get gameCore() : IGameCore {
			return _gameCore;
		}

		public function set gameCore( gameCore : IGameCore ) : void {
			_gameCore = gameCore;
		}
	}
}
