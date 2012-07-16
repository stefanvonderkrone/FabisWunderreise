package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IGameScene;
	import com.flashmastery.as3.game.interfaces.core.IGraphicsCore;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class BaseGraphicsCore extends InteractiveGameObject implements IGraphicsCore {
		
		protected var _scenes : Vector.<IGameScene>;
		protected var _stage : DisplayObjectContainer;
		protected var _viewPort : Rectangle;

		public function BaseGraphicsCore() {
			super();
		}

		protected function addedToStageHandler( evt : Event ) : void {
			_stage.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			setStage( _stage.stage );
		}
		
		override protected function handleDisposal() : void {
			if ( _scenes != null && _scenes.length > 0 ) {
				var index : int = _scenes.length;
				while ( --index >= 0 )
					removeSceneAt( index, true );
			}
			_viewPort = null;
			if ( _stage != null )
				_stage.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			_stage = null;
		}

		protected function addSceneToEngine( scene : IGameScene ) : void {
		}

		protected function addSceneToEngineAt( scene : IGameScene, index : uint ) : void {
		}

		protected function applyViewPort() : void {
			if ( _scenes.length > 0 ) {
				var index : int = _scenes.length;
				while ( --index >= 0 )
					_scenes[ index ].setSize( _viewPort.width, _viewPort.height );
			}
		}

		protected function removeSceneFromEngineAt( scene : IGameScene, index : int ) : void {
		}

		protected function setStage( stage : Stage ) : void {
		}

		protected function swapScenesInEngine( scene1 : IGameScene, scene2 : IGameScene ) : void {
		}

		override protected function handleCreation() : void {
			_scenes = new Vector.<IGameScene>();
			_viewPort = new Rectangle();
		}

		final public function addScene( scene : IGameScene ) : IGameScene {
			const sceneIndex : int = _scenes.indexOf( scene );
			if ( sceneIndex >= 0 ) _scenes.splice( sceneIndex, 1 );
			_scenes.push( scene );
			addSceneToEngine( scene );
			return scene;
		}

		final public function addSceneAt( scene : IGameScene, index : uint ) : IGameScene {
			const sceneIndex : int = _scenes.indexOf( scene );
			if ( sceneIndex != index ) {
				if ( sceneIndex >= 0 )
					_scenes.splice( sceneIndex, 1 );
				_scenes.splice( index, 0, scene );
				addSceneToEngineAt( scene, index );
			}
			return scene;
		}

		final public function contains( scene : IGameScene ) : Boolean {
			return _scenes.indexOf( scene ) >= 0;
		}

		final public function getSceneAt( index : uint ) : IGameScene {
			return ( index >= 0 && index < _scenes.length ) ? _scenes[ index ] : null;
		}

		final public function getSceneByName( name : String ) : IGameScene {
			var index : int = _scenes.length;
			var scene : IGameScene;
			while ( --index >= 0 ) {
				scene = _scenes[ index ];
				if ( scene.name == name )
					return scene;
			}
			return null;
		}

		final public function getSceneIndex( scene : IGameScene ) : int {
			return _scenes.indexOf( scene );
		}

		final public function removeScene( scene : IGameScene, dispose : Boolean = false ) : IGameScene {
			const index : int = _scenes.indexOf( scene );
			if ( index >= 0 ) {
				_scenes.splice( index, 1 );
				removeSceneFromEngineAt( scene, index );
			}
			return scene;
		}

		final public function removeSceneAt( index : uint, dispose : Boolean = false ) : IGameScene {
			const scene : IGameScene = index < _scenes.length ? _scenes[ index ] : null;
			if ( scene ) {
				_scenes.splice( index, 1 );
				removeSceneFromEngineAt( scene, index );
			}
			return scene;
		}

		final public function removeScenes( beginIndex : uint = 0, endIndex : int = -1, dispose : Boolean = false ) : void {
			endIndex = endIndex < 0 ? _scenes.length : Math.min( endIndex, _scenes.length );
			var scene : IGameScene;
			while ( --endIndex >= beginIndex ) {
				scene = _scenes[ endIndex ];
				if ( scene ) {
					_scenes.splice( endIndex, 1 );
					removeSceneFromEngineAt( scene, endIndex );
				}
			}
		}

		final public function setSceneIndex( scene : IGameScene, index : uint ) : void {
			addSceneAt( scene, index );
		}

		final public function setupWithStage( stage : DisplayObjectContainer ) : void {
			_stage = stage;
			if ( _stage.stage != null ) {
				setStage( _stage.stage );
			} else _stage.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}

		final public function swapScenes( scene1 : IGameScene, scene2 : IGameScene ) : void {
			const index1 : int = _scenes.indexOf( scene1 );
			const index2 : int = _scenes.indexOf( scene2 );
			if ( index1 >= 0 && index2 >= 0 ) {
				if ( index1 < index2 ) {
					setSceneIndex( scene1, index2 );
					setSceneIndex( scene2, index1 );
				} else {
					setSceneIndex( scene2, index1 );
					setSceneIndex( scene1, index2 );
				}
				swapScenesInEngine( scene1, scene2 );
			}
		}

		final public function swapScenesAt( index1 : uint, index2 : uint ) : void {
			if ( index1 >= 0 && index1 < _scenes.length && index2 >= 0 && index2 < _scenes.length ) {
				const scene1 : IGameScene = _scenes[ index1 ];
				const scene2 : IGameScene = _scenes[ index2 ];
				if ( index1 < index2 ) {
					setSceneIndex( scene1, index2 );
					setSceneIndex( scene2, index1 );
				} else {
					setSceneIndex( scene2, index1 );
					setSceneIndex( scene1, index2 );
				}
				swapScenesInEngine( scene1, scene2 );
			}
		}

		final public function get stage() : DisplayObjectContainer {
			return _stage;
		}

		public function get graphicsStage() : Object {
			return null;
		}
		
		public function get graphicsEngine() : Object {
			return null;
		}

		public function update( deltaTime : Number ) : void {
		}

		final public function setPosition( x : Number, y : Number ) : void {
			_viewPort.x = x;
			_viewPort.y = y;
			applyViewPort();
		}

		final public function setSize( width : Number, height : Number ) : void {
			_viewPort.width = width;
			_viewPort.height = height;
			applyViewPort();
		}

		final public function get viewPort() : Rectangle {
			return _viewPort.clone();
		}
	}
}
