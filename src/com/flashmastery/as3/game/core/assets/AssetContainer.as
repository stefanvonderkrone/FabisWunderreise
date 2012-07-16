package com.flashmastery.as3.game.core.assets {

	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import com.flashmastery.as3.game.interfaces.assets.IAssetContainer;
	import com.flashmastery.as3.game.interfaces.assets.IAsset;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class AssetContainer extends Object implements IAssetContainer {
		
		protected static const NAME : String = "AssetContainer";
		protected static var index : uint = 0;
		
		protected var _assets : Vector.<IAsset>;
		protected var _name : String;
		
		public function AssetContainer() {
			init();
		}

		protected function init() : void {
			_assets = new Vector.<IAsset>();
			_name = NAME + ( index++ ).toString();
		}

		public function addAsset( asset : IAsset ) : IAsset {
			const index : int = _assets.indexOf( asset );
			if ( index < 0 )
				_assets.push( asset );
			return asset;
		}

		public function addAssets( assets : Vector.<IAsset> ) : void {
			var index : int = assets.length;
			while ( --index >= 0 )
				addAsset( assets[ index ] );
		}

		public function getAssetByName( name : String ) : IAsset {
			var index : int = _assets.length;
			var asset : IAsset;
			while ( --index >= 0 ) {
				asset = _assets[ index ];
				if ( asset.name == name )
					return asset;
			}
			return null;
		}

		public function removeAsset( asset : IAsset ) : IAsset {
			const index : int = _assets.indexOf( asset );
			if ( index >= 0 )
				_assets.splice( index, 1 );
			return asset;
		}

		public function removeAssetByName( name : String ) : IAsset {
			const asset : IAsset = getAssetByName( name );
			if ( asset != null ) removeAsset( asset );
			return asset;
		}

		public function removeAssets( assets : Vector.<IAsset> ) : void {
			var index : int = assets.length;
			while ( --index >= 0 )
				removeAsset( assets[ index ] );
		}

		public function removeAllAssets() : void {
			_assets.length = 0;
		}

		public function removeAndDisposeAllAssets() : void {
			var index : int = _assets.length;
			var asset : IAsset;
			while ( --index >= 0 ) {
				asset = _assets[ index ];
				if ( asset.asset is Bitmap && Bitmap( asset.asset ).bitmapData != null )
					Bitmap( asset.asset ).bitmapData.dispose();
				else if ( asset.asset is BitmapData )
					BitmapData( asset.asset ).dispose();
				asset.asset = null;
			}
			_assets.length = 0;
		}

		public function get name() : String {
			return _name;
		}

		public function set name( name : String ) : void {
			_name = name;
		}
	}
}
