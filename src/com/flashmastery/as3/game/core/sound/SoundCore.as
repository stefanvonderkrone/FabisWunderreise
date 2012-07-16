package com.flashmastery.as3.game.core.sound {

	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.media.Sound;
	import flash.media.SoundTransform;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class SoundCore extends Object implements ISoundCore {
		
		protected var _created : Boolean;
		private var _muted : Boolean;
		private var _soundTransform : SoundTransform;
		private var _volume : Number;

		public function SoundCore() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				_created = true;
				handleCreation();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}

		public function registerSound( name : String, sound : Sound ) : ISoundItem {
			return null;
		}

		public function registerSoundFromURL( name : String, url : String ) : ISoundItem {
			return null;
		}

		public function registerEmptySound( name : String ) : ISoundItem {
			return null;
		}

		public function registerSoundItem( soundItem : ISoundItem ) : ISoundItem {
			return null;
		}

		public function getSoundByName( name : String ) : ISoundItem {
			return null;
		}

		public function getSoundByURL( url : String ) : ISoundItem {
			return null;
		}

		public function removeSoundByName( name : String ) : ISoundItem {
			return null;
		}

		public function removeSoundByURL( url : String ) : ISoundItem {
			return null;
		}

		public function removeSoundItem( soundItem : ISoundItem ) : ISoundItem {
			return null;
		}

		public function removeSound( sound : Sound ) : ISoundItem {
			return null;
		}

		public function removeAllSounds() : void {
		}

		public function stopAllSounds() : void {
		}

		final public function get muted() : Boolean {
			return _muted;
		}

		final public function get soundTransform() : SoundTransform {
			return _soundTransform;
		}

		final public function get volume() : Number {
			return _volume;
		}

		public function set muted( muted : Boolean ) : void {
			_muted = muted;
		}

		public function set soundTransform( soundTransform : SoundTransform ) : void {
			_soundTransform = soundTransform;
		}

		public function set volume( volume : Number ) : void {
			_volume = volume;
		}
	}
}
