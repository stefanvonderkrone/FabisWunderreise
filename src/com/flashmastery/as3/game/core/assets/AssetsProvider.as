package com.flashmastery.as3.game.core.assets {
	import com.flashmastery.as3.game.interfaces.assets.IAssetsProvider;
	import com.flashmastery.as3.game.interfaces.assets.IAssetContainer;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class AssetsProvider extends Object implements IAssetsProvider {
		
		protected var _containerList : Vector.<IAssetContainer>;
		
		public function AssetsProvider() {
			init();
		}

		protected function init() : void {
			_containerList = new Vector.<IAssetContainer>();
		}
		
		public function addAssetContainer(assetContainer : IAssetContainer) : IAssetContainer {
			const index : int = _containerList.indexOf( assetContainer );
			if ( index < 0 )
				_containerList.push( assetContainer );
			return assetContainer;
		}

		public function getAssetContainerByName(name : String) : IAssetContainer {
			var index : int = _containerList.length;
			var container : IAssetContainer;
			while ( --index >= 0 ) {
				container = _containerList[ index ];
				if ( container.name == name )
					return container;
			}
			return null;
		}

		public function removeAssetContainer(assetContainer : IAssetContainer) : IAssetContainer {
			const index : int = _containerList.indexOf( assetContainer );
			if ( index >= 0 )
				_containerList.splice( index, 1 );
			return assetContainer;
		}

		public function removeAssetContainerByName(name : String) : IAssetContainer {
			const container : IAssetContainer = getAssetContainerByName( name );
			if ( container != null ) removeAssetContainer( container );
			return container;
		}

		public function removeAllAssetContainer() : void {
			_containerList.length = 0;
		}

		public function removeAndDisposeAllAssetContainer() : void {
			var index : int = _containerList.length;
			while ( --index >= 0 )
				_containerList[ index ].removeAndDisposeAllAssets();
			_containerList.length = 0;
		}

		public function dispose() : void {
			removeAndDisposeAllAssetContainer();
			_containerList = null;
		}
	}
}
