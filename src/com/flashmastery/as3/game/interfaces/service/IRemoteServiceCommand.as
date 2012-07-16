package com.flashmastery.as3.game.interfaces.service {

	import com.flashmastery.as3.game.interfaces.core.IAutoDisposable;
	import com.flashmastery.as3.game.interfaces.delegates.IRemoteServiceResponseDelegate;
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IRemoteServiceCommand extends IAutoDisposable {
		
		function get command() : String;
		function set command( command : String ) : void;
		
		function get arguments() : Array;
		function set arguments( arguments : Array ) : void;
		
		function get responseArguments() : Array;
		function set responseArguments( responseArgumnents : Array ) : void;
		
		function get responseDelegate() : IRemoteServiceResponseDelegate;
		function set responseDelegate( delegate : IRemoteServiceResponseDelegate ) : void;
		
		function get result() : Object;
		function set result( result : Object ) : void;
	}
}
