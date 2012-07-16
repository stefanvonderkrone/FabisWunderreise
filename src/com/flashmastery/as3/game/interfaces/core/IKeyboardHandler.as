package com.flashmastery.as3.game.interfaces.core {

	import flash.display.DisplayObjectContainer;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IKeyboardHandler extends IRecycable {
		
		function get altLeft() : Boolean;
		function get altRight() : Boolean;
		function get alt() : Boolean;
		
		function get cmdLeft() : Boolean;
		function get cmdRight() : Boolean;
		function get cmd() : Boolean;
		
		function get ctrlLeft() : Boolean;
		function get ctrlRight() : Boolean;
		function get ctrl() : Boolean;
		
		function get shiftLeft() : Boolean;
		function get shiftRight() : Boolean;
		function get shift() : Boolean;
		
		function get arrowDown() : Boolean;
		function get arrowLeft() : Boolean;
		function get arrowRight() : Boolean;
		function get arrowUp() : Boolean;
		
		function get space() : Boolean;
		
		function get enabled() : Boolean;
		function set enabled( enabled : Boolean ) : void; 
		
		function isKeyPressed( key : Object ) : Boolean;
		
		function setupWithStage( stage : DisplayObjectContainer ) : void;
		
	}
}
