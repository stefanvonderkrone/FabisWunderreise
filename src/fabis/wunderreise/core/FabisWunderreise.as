package fabis.wunderreise.core {

	import com.junkbyte.console.Cc;
	import fabis.wunderreise.scenes.FabisMainMenu;

	import com.flashmastery.as3.game.core.FlashGraphicsCore;
	import com.flashmastery.as3.game.core.GameCore;
	import com.flashmastery.as3.game.core.KeyboardHandler;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.delegates.IGameDelegate;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;

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
			TweenPlugin.activate( [ FramePlugin ] );
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
			_gameCore.director.runWithScene( new FabisMainMenu() );
			_gameCore.graphicsCore.setSize( stage.stageWidth, stage.stageHeight );
			_gameCore.start();
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
