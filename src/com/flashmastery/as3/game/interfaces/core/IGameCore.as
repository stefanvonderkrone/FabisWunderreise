package com.flashmastery.as3.game.interfaces.core {

	import com.flashmastery.as3.game.interfaces.assets.IAssetsProvider;
	import com.flashmastery.as3.game.interfaces.loading.ILoaderCore;
	import com.flashmastery.as3.game.interfaces.service.IRemoteServiceProvider;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IGameCore extends IInteractiveGameObject {
		
		function get isKeyboadEnabled() : Boolean;
		function set isKeyboadEnabled( value : Boolean ) : void;
		function get isAccelerometerEnabled() : Boolean;
		function set isAccelerometerEnabled( value : Boolean ) : void;
		
		function get keyboardHandler() : IKeyboardHandler;
		function get accelerometer() : IAccelerometer;
		function get achievementsCore() : IAchievementsCore;
		function get soundCore() : ISoundCore;
		function get assetsProvider() : IAssetsProvider;
		function get juggler() : IGameJuggler;
		function get director() : IGameDirector;
		function get graphicsCore() : IGraphicsCore;
		function get loaderCore() : ILoaderCore;
		function get remoteServiceProvider() : IRemoteServiceProvider;
		function get localStorage() : ILocalStorage;
		
		function setupWithStage( stage : DisplayObjectContainer ) : void;
		function setupWithGameDirector( director : IGameDirector ) : void;
		function setupWithGraphicsCore( graphicsCore : IGraphicsCore ) : void;
		function setupWithGameJuggler( juggler : IGameJuggler ) : void;
		function setupWithSoundCore( soundCore : ISoundCore ) : void;
		function setupWithAssetsProvider( assetsProvider : IAssetsProvider ) : void;
		function setupWithKeyboardHandler( keyboardHandler : IKeyboardHandler ) : void;
		function setupWithAccelerometer( accelerometer : IAccelerometer ) : void;
		function setupWithLoaderCore( loaderCore : ILoaderCore ) : void;
		function setupWithRemoteServiceProvider( remoteServiceProvider : IRemoteServiceProvider ) : void;
		function setupWithLocalStorage( localStorage : ILocalStorage ) : void;
		function setupWithAchievementsCore( achievementsCore : IAchievementsCore ) : void;
		function autoSetupOnStageReceived() : void;
		
	}
}
