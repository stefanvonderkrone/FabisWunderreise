package com.flashmastery.as3.game.interfaces.core {
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ILocalStorage extends IRecycable {
		
		function setupWithOptions( options : Object ) : void;
		function setupWithStorageObject( storageObject : Object, replaceLoadedStorageObject : Boolean = false ) : void;
		function getStorageObject() : Object;
		function saveStorage() : void;
		function loadStorage() : void;
	}
}
