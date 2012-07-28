package com.flashmastery.as3.game.interfaces.sound {

	import com.flashmastery.as3.game.interfaces.core.IRecycable;
	import com.flashmastery.as3.collections.interfaces.IImmutableList;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;

	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ISoundItem extends IRecycable {
		
		function get name() : String;
		function set name( name : String ) : void;
		
		function get sound() : Sound;
		function get soundChannels() : IImmutableList;
		
		function get bytesLoaded() : uint;
		function get bytesTotal() : int;
		function get progress() : Number;
				
		function play( startTime : Number = 0, loops : int = 0, soundTransform : SoundTransform = null ) : void;
		function stop() : void;

		function get leftPeak() : Number;
		function get position() : Number;
		function get rightPeak() : Number;
		
		function get soundTransform() : SoundTransform;
		function set soundTransform( soundTransform : SoundTransform ) : void;
		function get volume() : Number;
		function set volume( volume : Number ) : void;
		function get muted() : Boolean;
		function set muted( muted : Boolean ) : void;
		
		function get delegate() : ISoundItemDelegate;
		function set delegate( delegate : ISoundItemDelegate ) : void;
		
	}
}
