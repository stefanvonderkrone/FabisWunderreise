package com.flashmastery.as3.game.interfaces.service {

	import com.flashmastery.as3.game.interfaces.core.IRecycable;
	import com.flashmastery.as3.game.interfaces.delegates.IRemoteServiceProviderDelegate;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IRemoteServiceProvider extends IRecycable {
		
		function connectToURL( url : String, ...args ) : void;
		function close() : void;
		function call( command : IRemoteServiceCommand ) : void;
		
		function get connected() : Boolean;
		
		function get delegate() : IRemoteServiceProviderDelegate;

		function set delegate( delegate : IRemoteServiceProviderDelegate ) : void;
	}
}
