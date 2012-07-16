package com.flashmastery.as3.game.interfaces.loading {

	import com.flashmastery.as3.game.interfaces.core.IRecycable;
	import com.flashmastery.as3.game.interfaces.delegates.ILoaderCoreDelegate;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ILoaderCore extends IRecycable {
		
		function loadItem( item : ILoaderItem ) : void;
		function loadItems( items : Vector.<ILoaderItem> ) : void;
		
		function addDelegate( delegate : ILoaderCoreDelegate ) : void;
		function removeDelegate( delegate : ILoaderCoreDelegate ) : void;
		function start() : void;
		function stop() : void;
		
	}
}
