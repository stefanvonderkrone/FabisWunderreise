package com.flashmastery.as3.game.interfaces.loading {

	import com.flashmastery.as3.game.interfaces.core.IAutoDisposable;
	import com.flashmastery.as3.game.interfaces.delegates.ILoaderItemDelegate;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ILoaderItem extends IAutoDisposable {

		function get name() : String;
		function set name( name : String ) : void;

		function get type() : uint;
		function set type( type : uint ) : void;

		function get url() : String;
		function set url( url : String ) : void;

		function get assetContainerName() : String;
		function set assetContainerName( name : String ) : void;

		function get delegate() : ILoaderItemDelegate;
		function set delegate( delegate : ILoaderItemDelegate ) : void;

		function get options() : Object;
		function set options( options : Object ) : void;
	}
}
