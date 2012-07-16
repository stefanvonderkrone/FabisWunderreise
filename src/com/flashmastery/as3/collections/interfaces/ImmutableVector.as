package com.flashmastery.as3.collections.interfaces {

	import com.flashmastery.as3.collections.interfaces.IImmutableList;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class ImmutableVector extends Object implements IImmutableList {
		
		protected var _vector : Vector.<Object>;

		public function ImmutableVector() {
		}

		public function setupWithList( list : Object ) : void {
			_vector = Vector.<Object>( list );
		}

		public function getItemAt( index : uint ) : Object {
			return _vector[ index ];
		}

		public function getCopyOfList() : Object {
			return _vector.concat();
		}

		public function get length() : uint {
			return _vector.length;
		}
	}
}
