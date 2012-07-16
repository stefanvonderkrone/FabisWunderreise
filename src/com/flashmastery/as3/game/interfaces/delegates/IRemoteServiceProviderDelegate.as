package com.flashmastery.as3.game.interfaces.delegates {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IRemoteServiceProviderDelegate extends IRemoteServiceResponseDelegate {
		
		function reactOnConnection() : void;
	}
}
