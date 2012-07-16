package com.flashmastery.as3.collections.interfaces {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IImmutableList {
		
		function setupWithList( list : Object ) : void;
		function getItemAt( index : uint ) : Object;
		function getCopyOfList() : Object;
		
		function get length() : uint;
		
	}
}
