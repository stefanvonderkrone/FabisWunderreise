package com.flashmastery.as3.game.interfaces.core {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IAutoDisposable extends IRecycable {
		
		function get autoDispose() : Boolean;
		function set autoDispose( autoDispose : Boolean ) : void;
	}
}
