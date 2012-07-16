package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IGameScene;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FlashGraphicsCore extends BaseGraphicsCore {
		
		protected var _container : Sprite;

		public function FlashGraphicsCore() {
			super();
		}
		
		override protected function handleCreation() : void {
			_container = new Sprite();
			_container.name = "FlashGraphicsCore";
			super.handleCreation();
		}
		
		final override protected function addSceneToEngine( scene : IGameScene ) : void {
			scene.setSize( _viewPort.width, _viewPort.height );
			_container.addChild( DisplayObject( scene.getView() ) );
		}
		
		final override protected function addSceneToEngineAt( scene : IGameScene, index : uint ) : void {
			scene.setSize( _viewPort.width, _viewPort.height );
			_container.addChildAt( DisplayObject( scene.getView() ), index );
		}
		
		final override protected function swapScenesInEngine( scene1 : IGameScene, scene2 : IGameScene ) : void {
			_container.swapChildren( DisplayObject( scene1.getView() ), DisplayObject( scene2.getView() ) );
		}
		
		final override protected function removeSceneFromEngineAt( scene : IGameScene, index : int ) : void {
			scene;
			_container.removeChildAt( index );
		}
		
		final override protected function applyViewPort() : void {
			const scrollRect : Rectangle = _viewPort.clone();
			scrollRect.x = scrollRect.y = 0;
			_container.x = _viewPort.x;
			_container.y = _viewPort.y;
			_container.scrollRect = scrollRect;
			super.applyViewPort();
		}
		
		final override protected function setStage( stage : Stage ) : void {
			stage;
			_stage.addChild( _container );
			applyViewPort();
		}
		
		final override public function get graphicsStage() : Object {
			return _stage;
		}
		
		final override public function get graphicsEngine() : Object {
			return _container;
		}
	}
}
