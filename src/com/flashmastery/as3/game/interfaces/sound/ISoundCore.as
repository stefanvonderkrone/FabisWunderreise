package com.flashmastery.as3.game.interfaces.sound {

	import flash.media.SoundLoaderContext;
	import com.flashmastery.as3.game.interfaces.core.IRecycable;

	import flash.media.Sound;
	import flash.media.SoundTransform;

	/**
	 * @author Stefan von der Krone (2011)
	 */
	public interface ISoundCore extends IRecycable {

		function registerSound( name : String, sound : Sound ) : ISoundItem;
		function registerSoundFromURL( name : String, url : String, context : SoundLoaderContext = null ) : ISoundItem;
		function registerEmptySound( name : String, context : SoundLoaderContext = null ) : ISoundItem;
		function registerSoundItem( soundItem : ISoundItem ) : ISoundItem;
		function getSoundByName( name : String ) : ISoundItem;
		function getSoundByURL( url : String ) : ISoundItem;

		function removeSoundByName( name : String ) : ISoundItem;
		function removeSoundByURL( url : String ) : ISoundItem;
		function removeSoundItem( soundItem : ISoundItem ) : ISoundItem;
		function removeSound( sound : Sound ) : ISoundItem;
		function removeAllSounds( disposeAllSounds : Boolean = true ) : void;

		function stopAllSounds() : void;

		function get muted() : Boolean;
		function set muted( muted : Boolean ) : void;
		function get soundTransform() : SoundTransform;
		function set soundTransform( soundTransform : SoundTransform ) : void;
		function get volume() : Number;
		function set volume( volume : Number ) : void;
	}
}
