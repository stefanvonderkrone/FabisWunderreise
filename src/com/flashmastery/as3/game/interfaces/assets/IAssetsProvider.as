package com.flashmastery.as3.game.interfaces.assets {

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IAssetsProvider {
		
		function addAssetContainer( assetContainer : IAssetContainer ) : IAssetContainer;
		function dispose() : void;
		function getAssetContainerByName( name : String ) : IAssetContainer;
		function removeAssetContainer( assetContainer : IAssetContainer ) : IAssetContainer;
		function removeAssetContainerByName( name : String ) : IAssetContainer;
		function removeAllAssetContainer() : void;
		function removeAndDisposeAllAssetContainer() : void;
	}
}
