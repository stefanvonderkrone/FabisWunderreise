package com.flashmastery.as3.game.core.assets {

	import com.flashmastery.as3.game.interfaces.assets.IAsset;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class Asset extends Object implements IAsset {
		
		private static const NAME : String = "Asset";
		private static var _index : int = 0;
		
		protected var _name : String;
		protected var _type : uint;
		protected var _asset : Object;

		public function Asset() {
			init();
		}

		protected function init() : void {
			_name = NAME + ( _index++ ).toString();
		}

		public function get name() : String {
			return _name;
		}

		public function get asset() : Object {
			return _asset;
		}

		public function get type() : uint {
			return _type;
		}

		public function set name( name : String ) : void {
			_name = name;
		}

		public function set asset( asset : Object ) : void {
			_asset = asset;
		}

		public function set type( type : uint ) : void {
			_type = type;
		}
	}
}
