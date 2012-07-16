package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.core.assets.AssetsProvider;
	import com.flashmastery.as3.game.core.loading.LoaderCore;
	import com.flashmastery.as3.game.core.sound.SoundCore;
	import com.flashmastery.as3.game.interfaces.assets.IAssetsProvider;
	import com.flashmastery.as3.game.interfaces.core.IAccelerometer;
	import com.flashmastery.as3.game.interfaces.core.IAchievementsCore;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IGameDirector;
	import com.flashmastery.as3.game.interfaces.core.IGameJuggler;
	import com.flashmastery.as3.game.interfaces.core.IGraphicsCore;
	import com.flashmastery.as3.game.interfaces.core.IKeyboardHandler;
	import com.flashmastery.as3.game.interfaces.core.ILocalStorage;
	import com.flashmastery.as3.game.interfaces.loading.ILoaderCore;
	import com.flashmastery.as3.game.interfaces.service.IRemoteServiceProvider;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class GameCore extends InteractiveGameObject implements IGameCore {

		protected var _stage : DisplayObjectContainer;
		protected var _isKeyboadEnabled : Boolean;
		protected var _isAccelerometerEnabled : Boolean;
		protected var _autoSetupOnStageReceived : Boolean;
		protected var _currentTime : int;
		protected var _graphicsCore : IGraphicsCore;
		protected var _keyboardHandler : IKeyboardHandler;
		protected var _accelerometer : IAccelerometer;
		protected var _soundCore : ISoundCore;
		protected var _assetProvider : IAssetsProvider;
		protected var _juggler : IGameJuggler;
		protected var _director : IGameDirector;
		protected var _loaderCore : ILoaderCore;
		protected var _remoteServiceProvider : IRemoteServiceProvider;
		protected var _localStorage : ILocalStorage;
		protected var _achievementsCore : IAchievementsCore;

		public function GameCore() {
			super();
		}

		override protected function handleCreation() : void {
			_gameCore = this;
			_currentTime = getTimer();
		}

		override protected function handleDisposal() : void {
			disposeKeyboardHandler();
			disposeAccelerometer();
			disposeJuggler();
			disposeDirector();
			disposeGraphicsCore();
			disposeSoundCore();
			disposeAssetsProvider();
			disposeLoaderCore();
			disposeRemoteServiceProvider();
			disposeLocalStorage();
			disposeAchievementsCore();
			_stage = null;
			_autoSetupOnStageReceived = false;
			_isAccelerometerEnabled = false;
			_isKeyboadEnabled = false;
			_currentTime = 0;
		}

		override protected function handleStart() : void {
			startUpdating();
			if ( _accelerometer != null )
				_accelerometer.enabled = _isAccelerometerEnabled;
			if ( _keyboardHandler != null )
				_keyboardHandler.enabled = _isKeyboadEnabled;
			if ( _director != null )
				_director.start();
			if ( _graphicsCore != null )
				_graphicsCore.start();
		}

		override protected function handleStop() : void {
			stopUpdating();
			if ( _accelerometer != null )
				_accelerometer.enabled = false;
			if ( _keyboardHandler != null )
				_keyboardHandler.enabled = false;
			if ( _director != null )
				_director.stop();
			if ( _graphicsCore != null )
				_graphicsCore.stop();
		}

		protected function createKeyboardHandler() : IKeyboardHandler {
			return new KeyboardHandler();
		}

		protected function createSoundCore() : ISoundCore {
			return new SoundCore();
		}

		protected function createAssetsProvider() : IAssetsProvider {
			return new AssetsProvider();
		}

		protected function createGameJuggler() : IGameJuggler {
			return new GameJuggler();
		}

		protected function createGameDirector() : IGameDirector {
			return new GameDirector();
		}

		protected function createLoaderCore() : ILoaderCore {
			return new LoaderCore();
		}

		protected function disposeAchievementsCore() : void {
			if ( _achievementsCore != null )
				_achievementsCore.dispose();
			_achievementsCore = null;
		}

		protected function disposeLocalStorage() : void {
			if ( _localStorage != null )
				_localStorage.dispose();
			_localStorage = null;
		}

		protected function disposeRemoteServiceProvider() : void {
			if ( _remoteServiceProvider != null )
				_remoteServiceProvider.dispose();
			_remoteServiceProvider = null;
		}

		protected function disposeLoaderCore() : void {
			if ( _loaderCore != null )
				_loaderCore.dispose();
			_loaderCore = null;
		}

		protected function disposeDirector() : void {
			if ( _director != null )
				_director.dispose();
			_director = null;
		}

		protected function disposeJuggler() : void {
			if ( _juggler != null )
				_juggler.dispose();
			_juggler = null;
		}

		protected function disposeAssetsProvider() : void {
			if ( _assetProvider != null )
				_assetProvider.dispose();
			_assetProvider = null;
		}

		protected function disposeSoundCore() : void {
			if ( _soundCore != null )
				_soundCore.dispose();
			_soundCore = null;
		}

		protected function disposeAccelerometer() : void {
			if ( _accelerometer != null )
				_accelerometer.dispose();
			_accelerometer = null;
		}

		protected function disposeKeyboardHandler() : void {
			if ( _keyboardHandler != null )
				_keyboardHandler.dispose();
			_keyboardHandler = null;
		}

		protected function disposeGraphicsCore() : void {
			if ( _graphicsCore != null )
				_graphicsCore.dispose();
			_graphicsCore = null;
		}

		protected function addedToStageHandler( evt : Event ) : void {
			_stage.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			setStage( _stage.stage );
		}

		protected function setStage( stage : Stage ) : void {
			_stage = stage;
			if ( _autoSetupOnStageReceived ) {
				setupWithGameDirector( createGameDirector() );
				setupWithGameJuggler( createGameJuggler() );
			}
			if ( _graphicsCore != null ) {
				_graphicsCore.setupWithStage( stage );
				if ( _director != null )
					_director.setupWithGraphicsCore( _graphicsCore );
			}
			if ( _keyboardHandler != null )
				_keyboardHandler.setupWithStage( _stage );
			if ( !_isRunning )
				startUpdating();
		}

		protected function startUpdating() : void {
			if ( _stage ) {
				_currentTime = getTimer();
				_stage.addEventListener( Event.ENTER_FRAME, enterframeHandler );
			}
		}

		protected function stopUpdating() : void {
			if ( _stage )
				_stage.removeEventListener( Event.ENTER_FRAME, enterframeHandler );
		}

		protected function enterframeHandler( evt : Event ) : void {
			const currentTime : int = getTimer();
			if ( _juggler != null )
				_juggler.update( ( currentTime - _currentTime ) / 1000 );
			_currentTime = currentTime;
		}

		public function autoSetupOnStageReceived() : void {
			_autoSetupOnStageReceived = true;
		}

		public function setupWithStage( stage : DisplayObjectContainer ) : void {
			if ( stage.stage != null ) setStage( stage.stage );
			else {
				_stage = stage;
				_stage.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			}
		}

		public function setupWithGameDirector( director : IGameDirector ) : void {
			_director = director;
			_director.gameCore = this;
			if ( _graphicsCore != null )
				_director.setupWithGraphicsCore( _graphicsCore );
		}

		public function setupWithGraphicsCore( graphicsCore : IGraphicsCore ) : void {
			_graphicsCore = graphicsCore;
			_graphicsCore.gameCore = this;
			if ( _stage != null )
				_graphicsCore.setupWithStage( _stage );
			if ( _director != null )
				_director.setupWithGraphicsCore( graphicsCore );
		}

		public function setupWithGameJuggler( juggler : IGameJuggler ) : void {
			_juggler = juggler;
		}

		public function setupWithSoundCore( soundCore : ISoundCore ) : void {
			_soundCore = soundCore;
		}

		public function setupWithAssetsProvider( assetsProvider : IAssetsProvider ) : void {
			_assetProvider = assetsProvider;
		}

		public function setupWithKeyboardHandler( keyboardHandler : IKeyboardHandler ) : void {
			_keyboardHandler = keyboardHandler;
			if ( _stage != null )
				_keyboardHandler.setupWithStage( _stage );
			if ( _keyboardHandler != null ) _isKeyboadEnabled = true;
		}

		public function setupWithAccelerometer( accelerometer : IAccelerometer ) : void {
			_accelerometer = accelerometer;
			if ( _accelerometer != null ) _isAccelerometerEnabled = true;
		}

		public function setupWithLoaderCore( loaderCore : ILoaderCore ) : void {
			_loaderCore = loaderCore;
		}

		public function setupWithRemoteServiceProvider( remoteServiceProvider : IRemoteServiceProvider ) : void {
			_remoteServiceProvider = remoteServiceProvider;
		}

		public function setupWithLocalStorage( localStorage : ILocalStorage ) : void {
			_localStorage = localStorage;
		}

		public function setupWithAchievementsCore( achievementsCore : IAchievementsCore ) : void {
			_achievementsCore = achievementsCore;
		}

		final public function get isKeyboadEnabled() : Boolean {
			return _isKeyboadEnabled;
		}

		final public function get isAccelerometerEnabled() : Boolean {
			return _isAccelerometerEnabled;
		}

		final public function get keyboardHandler() : IKeyboardHandler {
			return _isKeyboadEnabled ? _keyboardHandler : null;
		}

		final public function get accelerometer() : IAccelerometer {
			return _isAccelerometerEnabled ? _accelerometer : null;
		}

		final public function get achievementsCore() : IAchievementsCore {
			return _achievementsCore;
		}

		final public function get soundCore() : ISoundCore {
			return _soundCore;
		}

		final public function get assetsProvider() : IAssetsProvider {
			return _assetProvider;
		}

		final public function get juggler() : IGameJuggler {
			return _juggler;
		}

		final public function get director() : IGameDirector {
			return _director;
		}

		final public function get graphicsCore() : IGraphicsCore {
			return _graphicsCore;
		}

		final public function get loaderCore() : ILoaderCore {
			return _loaderCore;
		}

		final public function get remoteServiceProvider() : IRemoteServiceProvider {
			return _remoteServiceProvider;
		}

		final public function get localStorage() : ILocalStorage {
			return _localStorage;
		}

		final public function set isKeyboadEnabled( value : Boolean ) : void {
			_isKeyboadEnabled = value;
			if ( _keyboardHandler != null )
				_keyboardHandler.enabled = _isKeyboadEnabled;
		}

		final public function set isAccelerometerEnabled( value : Boolean ) : void {
			_isAccelerometerEnabled = value;
			if ( _accelerometer != null )
				_accelerometer.enabled = _isAccelerometerEnabled;
		}
	}
}
