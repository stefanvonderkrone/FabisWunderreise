package com.flashmastery.as3.game.interfaces.delegates {

	import com.flashmastery.as3.game.interfaces.loading.ILoaderItem;

	import flash.events.Event;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ILoaderItemDelegate {
		
		function reactOnLoaderItemStart( evt : Event, loaderItem : ILoaderItem ) : void;
		function reactOnLoaderItemProgress( evt : Event, loaderItem : ILoaderItem ) : void;
		function reactOnLoaderItemComplete( evt : Event, loaderItem : ILoaderItem ) : void;
		function reactOnLoaderItemError( evt : Event, loaderItem : ILoaderItem ) : void;
		
	}
}
