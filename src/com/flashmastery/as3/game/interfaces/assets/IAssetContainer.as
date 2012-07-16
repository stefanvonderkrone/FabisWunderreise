package com.flashmastery.as3.game.interfaces.assets {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IAssetContainer {
		
		function addAsset( asset : IAsset ) : IAsset;
		function addAssets( assets : Vector.<IAsset> ) : void;
		function getAssetByName( name : String ) : IAsset;
		function removeAsset( asset : IAsset ) : IAsset;
		function removeAssetByName( name : String ) : IAsset;
		function removeAssets( assets : Vector.<IAsset> ) : void;
		function removeAllAssets() : void;
		function removeAndDisposeAllAssets() : void;
		
		function get name() : String;
		function set name( name : String ) : void;
		
	}
}
