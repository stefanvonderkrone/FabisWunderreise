package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.collections.interfaces.IImmutableList;
	import com.flashmastery.as3.collections.interfaces.ImmutableVector;
	import com.flashmastery.as3.game.interfaces.core.IGameDirector;
	import com.flashmastery.as3.game.interfaces.core.IGameScene;
	import com.flashmastery.as3.game.interfaces.core.IGraphicsCore;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class GameDirector extends InteractiveGameObject implements IGameDirector {

		protected var _currentScene : IGameScene;
		protected var _scenes : Vector.<IGameScene>;
		protected var _graphicsCore : IGraphicsCore;
		
		public function GameDirector() {
			super();
			_scenes = new Vector.<IGameScene>();
		}
		
		override protected function handleStart() : void {
			if ( _scenes.length > 0 ) {
				var index : int = _scenes.length;
				while ( --index >= 0 )
					_scenes[ index ].start();
			}
		}
		
		override protected function handleStop() : void {
			if ( _scenes.length > 0 ) {
				var index : int = _scenes.length;
				while ( --index >= 0 )
					_scenes[ index ].stop();
			}
		}

		override protected function handleDisposal() : void {
			_currentScene = null;
			if ( _scenes.length > 0 ) {
				var index : int = _scenes.length;
				if ( _graphicsCore != null ) {
					while ( --index >= 0 )
						_graphicsCore.removeSceneAt( index, true );
				} else {
					while ( --index >= 0 )
						_scenes[ index ].dispose();
				}
			}
			_graphicsCore = null;
		}
		
		protected function setCurrentScene( scene : IGameScene ) : void {
			_currentScene = scene;
			const index : int = _scenes.indexOf( scene );
			if ( index < 0 ) _gameCore.juggler.addAnimatable( scene );
			else _scenes.splice( index, 1 );
			_scenes.push( scene );
			scene.gameCore = _gameCore;
			if ( _graphicsCore != null )
				_graphicsCore.addScene( scene );
			scene.reactOnAddedToDirector( this );
			if ( _isRunning )
				scene.start();
		}
		
		protected function removeScene( scene : IGameScene, disposeScene : Boolean = false ) : void {
			_gameCore.juggler.removeAnimatable( scene );
			scene.stop();
			scene.reactOnRemovedFromDirector();
			if ( _graphicsCore != null )
				_graphicsCore.removeScene( scene );
			if ( disposeScene )
				scene.dispose();
		}
		
		public function setupWithGraphicsCore( graphicsCore : IGraphicsCore ) : void {
			_graphicsCore = graphicsCore;
			if ( _scenes.length > 0 ) {
				const length : int = _scenes.length;
				for ( var i : uint = 0; i < length; i++ )
					pushScene( _scenes[ uint( i ) ] );
			}
		}

		public function runWithScene(scene : IGameScene, disposeExistingScenes : Boolean = true ) : void {
			clear( disposeExistingScenes );
			setCurrentScene( scene );
		}

		public function clear( disposeScenes : Boolean = true ) : void {
			_currentScene = null;
			var index : int = _scenes.length;
			while ( --index >= 0 )
				removeScene( _scenes.pop(), disposeScenes );
		}

		public function pushScene(scene : IGameScene) : void {
			setCurrentScene( scene );
		}

		public function popScene( disposeScene : Boolean = true ) : IGameScene {
			const scene : IGameScene = _scenes.pop();
			if ( scene != null )
				removeScene( scene, disposeScene );
			setCurrentScene( _scenes.length > 0 ? _scenes[ _scenes.length - 1 ] : null );
			return scene;
		}

		public function replaceScene( scene : IGameScene, disposeScene : Boolean = true) : void {
			var tempScene : IGameScene = _scenes.pop();
			if ( tempScene != null )
				removeScene( tempScene, disposeScene );
			setCurrentScene( scene );
		}

		public function getSceneByName(name : String) : IGameScene {
			var index : int = _scenes.length;
			var scene : IGameScene;
			while ( --index >= 0 ) {
				scene = _scenes[ index ];
				if ( scene.name == name )
					return scene;
			}
			return null;
		}

		public function getAllScenes() : IImmutableList {
			const list : ImmutableVector = new ImmutableVector();
			list.setupWithList( _scenes );
			return list;
		}

		public function get currentScene() : IGameScene {
			return _currentScene;
		}
	}
}
