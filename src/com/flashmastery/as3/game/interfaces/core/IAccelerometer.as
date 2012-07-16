package com.flashmastery.as3.game.interfaces.core {
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IAccelerometer extends IRecycable {
		
		function get angleXInRadiants() : Number;
		function get angleYInRadiants() : Number;
		function get angleZInRadiants() : Number;
		function get accelerationX() : Number;
		function get accelerationY() : Number;
		function get accelerationZ() : Number;
		function get enabled() : Boolean;
		function set enabled( enabled : Boolean ) : void;
	}
}
