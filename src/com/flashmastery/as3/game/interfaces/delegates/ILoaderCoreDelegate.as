package com.flashmastery.as3.game.interfaces.delegates {

	import flash.events.Event;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ILoaderCoreDelegate {
		
		function reactOnLoaderCoreStart( evt : Event ) : void;
		function reactOnLoaderCoreProgress( evt : Event ) : void;
		function reactOnLoaderCoreComplete( evt : Event ) : void;
		function reactOnLoaderCoreError( evt : Event ) : void;
	}
}
