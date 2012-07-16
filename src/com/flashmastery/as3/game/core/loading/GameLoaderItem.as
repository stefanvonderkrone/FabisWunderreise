package com.flashmastery.as3.game.core.loading {

	import com.flashmastery.as3.game.interfaces.loading.ILoaderItem;
	import com.flashmastery.as3.game.interfaces.delegates.ILoaderItemDelegate;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class GameLoaderItem extends Object implements ILoaderItem {

		private static const NAME : String = "LoaderItem";
		private static var _index : int = 0;

		protected var _name : String;
		protected var _type : uint;
		protected var _url : String;
		protected var _delegate : ILoaderItemDelegate;
		protected var _assetContainerName : String;
		protected var _options : Object;
		protected var _autoDispose : Boolean;
		protected var _created : Boolean;

		public function GameLoaderItem() {
			create();
		}

		final public function get name() : String {
			return _name;
		}

		final public function get type() : uint {
			return _type;
		}

		final public function get url() : String {
			return _url;
		}

		final public function get delegate() : ILoaderItemDelegate {
			return _delegate;
		}

		public function set name( name : String ) : void {
			_name = name;
		}

		public function set type( type : uint ) : void {
			_type = type;
		}

		public function set url( url : String ) : void {
			_url = url;
		}

		public function set delegate( delegate : ILoaderItemDelegate ) : void {
			_delegate = delegate;
		}

		final public function get assetContainerName() : String {
			return _assetContainerName;
		}

		public function set assetContainerName( name : String ) : void {
			_assetContainerName = name;
		}

		final public function get options() : Object {
			return _options;
		}

		public function set options( options : Object ) : void {
			_options = options;
		}

		final public function get autoDispose() : Boolean {
			return _autoDispose;
		}

		public function set autoDispose( autoDispose : Boolean ) : void {
			_autoDispose = autoDispose;
		}

		final public function create() : void {
			if ( !_created ) {
				_name = NAME + ( _index++ ).toString();
				_created = true;
				handleCreation();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}
	}
}
