package com.flashmastery.as3.game.core {
	import flash.net.SharedObject;
	import com.flashmastery.as3.game.interfaces.core.ILocalStorage;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class LocalStorageSO extends Object implements ILocalStorage {
		
		protected var _sharedObject : SharedObject;
		protected var _storageObject : Object;
		protected var _storageLoaded : Boolean;
		protected var _created : Boolean;
		
		public function LocalStorageSO() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				_created = true;
				_storageLoaded = false;
				handleCreation();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
			}
		}

		public function setupWithOptions( options : Object ) : void {
			const name : String = options.name;
			const localPath : String = options.localPath;
			const secure : Boolean = options.secure;
			_sharedObject = SharedObject.getLocal( name, localPath, secure );
			_storageObject = _sharedObject.data.storageObject;
			_storageLoaded = true;
		}

		public function setupWithStorageObject( storageObject : Object, replaceLoadedStorageObject : Boolean = false ) : void {
			if ( _storageObject == null || replaceLoadedStorageObject )
				_storageObject = storageObject;
		}

		final public function getStorageObject() : Object {
			return _storageObject;
		}

		public function saveStorage() : void {
			_sharedObject.data.storageObject = _storageObject;
			_sharedObject.flush();
		}

		public function loadStorage() : void {
			
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}
	}
}
