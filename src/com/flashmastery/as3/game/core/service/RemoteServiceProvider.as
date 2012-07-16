package com.flashmastery.as3.game.core.service {
	import com.flashmastery.as3.game.interfaces.service.IRemoteServiceProvider;
	import com.flashmastery.as3.game.interfaces.service.IRemoteServiceCommand;
	import com.flashmastery.as3.game.interfaces.delegates.IRemoteServiceProviderDelegate;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class RemoteServiceProvider extends Object implements IRemoteServiceProvider {
		
		protected var _created : Boolean;
		protected var _delegate : IRemoteServiceProviderDelegate;
		protected var _connected : Boolean;
		
		public function RemoteServiceProvider() {
			create();
		}

		public function connectToURL(url : String, ...args : *) : void {
		}

		public function close() : void {
		}

		public function call(command : IRemoteServiceCommand) : void {
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
				_delegate = null;
				_connected = false;
			}
		}

		final public function get connected() : Boolean {
			return _connected;
		}

		final public function get delegate() : IRemoteServiceProviderDelegate {
			return _delegate;
		}

		public function set delegate(delegate : IRemoteServiceProviderDelegate) : void {
		}

		final public function create() : void {
			if ( !_created ) {
				_created = true;
				handleCreation();
			}
		}

		protected function handleCreation() : void {
		}

		protected function handleDisposal() : void {
		}
	}
}
