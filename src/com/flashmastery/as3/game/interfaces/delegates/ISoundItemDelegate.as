package com.flashmastery.as3.game.interfaces.delegates {
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ISoundItemDelegate {
		
		function reactOnSoundItemProgressEvent( evt : ProgressEvent, soundItem : ISoundItem ) : void;
		function reactOnSoundItemEvent( evt : Event, soundItem : ISoundItem ) : void;
		function reactOnSoundItemSoundComplete( soundItem : ISoundItem ) : void;
		function reactOnSoundItemLoadComplete( soundItem : ISoundItem ) : void;
		function reactOnSoundItemErrorEvent( evt : ErrorEvent, soundItem : ISoundItem ) : void;
		function reactOnSoundItemSampleDataEvent( evt : SampleDataEvent, soundItem : ISoundItem ) : void;
		
	}
}
