package com.flashmastery.as3.game.interfaces.assets {
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IAsset {
		
		function get name() : String;
		function set name( name : String ) : void;
		
		function get asset() : Object;
		function set asset( asset : Object ) : void;
		
		function get type() : uint;
		function set type( type : uint ) : void;
		
	}
}
