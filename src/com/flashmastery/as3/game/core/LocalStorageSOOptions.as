package com.flashmastery.as3.game.core {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class LocalStorageSOOptions extends Object {

		public var name : String;
		public var localPath : String;
		public var secure : Boolean;

		public function LocalStorageSOOptions( name : String, localPath : String = null, secure : Boolean = false ) {
			this.name = name;
			this.localPath = localPath;
			this.secure = secure;
		}
	}
}
