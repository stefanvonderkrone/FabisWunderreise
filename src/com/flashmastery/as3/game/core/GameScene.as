package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IGameDirector;
	import com.flashmastery.as3.game.interfaces.core.IGameScene;

	import flash.geom.Rectangle;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class GameScene extends InteractiveGameObject implements IGameScene {
		
		protected static const NAME : String = "GameScene";
		protected static var index : uint = 0;

		protected var _name : String;
		protected var _view : Object;
		protected var _viewPort : Rectangle;

		public function GameScene() {
			super();
		}
		
		override protected function handleCreation() : void {
			_name = NAME + ( index++ ).toString();
			_viewPort = new Rectangle();
			super.handleCreation();
		}

		final public function get name() : String {
			return _name;
		}

		final public function set name( name : String ) : void {
			_name = name;
		}

		public function update( deltaTime : Number ) : void {
		}

		public function reactOnAddedToDirector( director : IGameDirector ) : void {
		}

		public function reactOnRemovedFromDirector() : void {
		}

		final public function getView() : Object {
			return _view;
		}

		public function setSize( width : Number, height : Number ) : void {
			_viewPort.width = width;
			_viewPort.height = height;
		}
	}
}
