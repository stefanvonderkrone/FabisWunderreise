package com.flashmastery.as3.game.interfaces.delegates {
	import com.flashmastery.as3.game.interfaces.service.IRemoteServiceCommand;
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IRemoteServiceResponseDelegate {
		
		function reactOnServiceResult( command : IRemoteServiceCommand ) : void;
		function reactOnServiceError( command : IRemoteServiceCommand ) : void;
	}
}
