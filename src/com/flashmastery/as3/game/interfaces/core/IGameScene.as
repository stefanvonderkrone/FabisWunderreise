package com.flashmastery.as3.game.interfaces.core {
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface IGameScene extends IInteractiveGameObject, IGameAnimatable {
		
		function get name() : String;
		function set name( name : String ) : void;
		
		function getView() : Object;
		function setSize( width : Number, height : Number ) : void;
		function reactOnAddedToDirector( director : IGameDirector ) : void;
		function reactOnRemovedFromDirector() : void;
	}
}
