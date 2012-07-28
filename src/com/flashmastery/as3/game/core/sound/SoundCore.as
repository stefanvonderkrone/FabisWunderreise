package com.flashmastery.as3.game.core.sound {

	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class SoundCore extends Object implements ISoundCore {
		
		protected var _created : Boolean;
		protected var _muted : Boolean;
		protected var _soundTransform : SoundTransform;
		protected var _volume : Number;
		protected var _soundItemList : Vector.<ISoundItem>;
		protected var _soundList : Vector.<Sound>;
		protected var _soundItemMap : Dictionary;
		protected var _soundItemURLMap : Dictionary;

		public function SoundCore() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				_created = true;
				_soundItemList = new Vector.<ISoundItem>();
				_soundList = new Vector.<Sound>();
				_soundItemMap = new Dictionary();
				_soundItemURLMap = new Dictionary();
				_volume = 1;
				_muted = false;
				handleCreation();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				removeAllSounds();
				_soundItemList = null;
				_soundItemMap = null;
				_soundItemURLMap = null;
				_soundList = null;
				_soundTransform = null;
				_muted = false;
				_volume = 1;
				SoundMixer.soundTransform = new SoundTransform();
				_created = false;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}

		protected function addSoundItem( soundItem : ISoundItem ) : void {
			const index : int = _soundItemList.indexOf( soundItem );
			if ( index < 0 ) {
				_soundItemList.push( soundItem );
				_soundList.push( soundItem.sound );
				_soundItemMap[ soundItem.name ] = soundItem;
				_soundItemURLMap[ soundItem.sound.url ] = soundItem;
			} else {
				_soundItemMap[ soundItem.name ] = soundItem;
				_soundItemURLMap[ soundItem.sound.url ] = soundItem;
			}
		}
		
		protected function hasSoundItem( soundIdentifier : Object ) : Boolean {
			const soundItem : ISoundItem = soundIdentifier as ISoundItem;
			const sound : Sound = soundIdentifier as Sound;
			const nameOrURL : String = soundIdentifier as String;
			if ( soundItem ) {
				return _soundItemList.indexOf( soundItem ) >= 0;
			} else if ( sound ) {
				return _soundList.indexOf( sound ) >= 0;
			} else if ( nameOrURL ) {
				return _soundItemMap[ nameOrURL ] != null || _soundItemURLMap[ nameOrURL ] != null;
			}
			return false;
		}
		
		protected function getSoundItem( soundIdentifier : Object ) : ISoundItem {
			const soundItem : ISoundItem = soundIdentifier as ISoundItem;
			const sound : Sound = soundIdentifier as Sound;
			const nameOrURL : String = soundIdentifier as String;
			if ( soundItem ) {
				return soundItem;
			} else if ( sound ) {
				return _soundItemList[ _soundList.indexOf( sound ) ];
			} else if ( nameOrURL ) {
				if ( _soundItemMap[ nameOrURL ] != null ) {
					return _soundItemMap[ nameOrURL ];
				} else if ( _soundItemURLMap[ nameOrURL ] != null ) {
					return _soundItemURLMap[ nameOrURL ];
				}
			}
			return null;
		}

		public function registerSound( name : String, sound : Sound ) : ISoundItem {
			var soundItem : ISoundItem;
			if ( hasSoundItem( name ) && hasSoundItem( sound ) ) {
				soundItem = getSoundItem( name );
			} else {
				soundItem = new SoundItem( sound );
			}
			soundItem.name = name;
			addSoundItem( soundItem );
			return soundItem;
		}

		public function registerSoundFromURL( name : String, url : String, context : SoundLoaderContext = null ) : ISoundItem {
			var soundItem : ISoundItem;
			if ( hasSoundItem( name ) && hasSoundItem( url ) ) {
				soundItem = getSoundItem( url );
			} else {
				soundItem = new SoundItem( new Sound( new URLRequest( url ), context ) );
			}
			soundItem.name = name;
			addSoundItem( soundItem );
			return soundItem;
		}

		public function registerEmptySound( name : String, context : SoundLoaderContext = null ) : ISoundItem {
			var soundItem : ISoundItem;
			if ( hasSoundItem( name ) ) {
				soundItem = getSoundItem( name );
			} else {
				soundItem = new SoundItem( new Sound( null, context ) );
			}
			soundItem.name = name;
			addSoundItem( soundItem );
			return soundItem;
		}

		public function registerSoundItem( soundItem : ISoundItem ) : ISoundItem {
			addSoundItem( soundItem );
			return soundItem;
		}

		public function getSoundByName( name : String ) : ISoundItem {
			return hasSoundItem( name ) ? getSoundItem( name ) : null;
		}

		public function getSoundByURL( url : String ) : ISoundItem {
			return hasSoundItem( url ) ? getSoundItem( url ) : null;
		}

		public function removeSoundByName( name : String ) : ISoundItem {
			if ( hasSoundItem( name ) ) {
				return removeSoundItem( getSoundItem( name ) );
			}
			return null;
		}

		public function removeSoundByURL( url : String ) : ISoundItem {
			if ( hasSoundItem( url ) ) {
				return removeSoundItem( getSoundItem( url ) );
			}
			return null;
		}

		public function removeSoundItem( soundItem : ISoundItem ) : ISoundItem {
			if ( hasSoundItem( soundItem ) ) {
				_soundItemList.splice( _soundItemList.indexOf( soundItem ), 1 );
				_soundList.splice( _soundList.indexOf( soundItem.sound ), 1 );
				if ( _soundItemMap[ soundItem.name ] == soundItem ) {
					delete _soundItemMap[ soundItem.name ];
				}
				if ( _soundItemURLMap[ soundItem.sound.url ] == soundItem ) {
					delete _soundItemURLMap[ soundItem.sound.url ];
				}
			}
			return soundItem;
		}

		public function removeSound( sound : Sound ) : ISoundItem {
			if ( hasSoundItem( sound ) ) {
				return removeSoundItem( getSoundItem( sound ) );
			}
			return null;
		}

		public function removeAllSounds( disposeAllSounds : Boolean = true ) : void {
			stopAllSounds();
			if ( disposeAllSounds ) {
				var numSounds : int = _soundItemList.length;
				while ( --numSounds >= 0 ) {
					_soundItemList[ int( numSounds ) ].dispose();
				}
			}
			_soundItemList.length = 0;
			_soundList.length = 0;
			_soundItemMap = new Dictionary();
			_soundItemURLMap = new Dictionary();
		}

		public function stopAllSounds() : void {
			var numSounds : int = _soundItemList.length;
			while ( --numSounds >= 0 ) {
				_soundItemList[ int( numSounds ) ].stop();
			}
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
			_soundTransform.volume = _muted ? 0 : _volume;
			SoundMixer.soundTransform = _soundTransform;
		}

		public function set soundTransform( soundTransform : SoundTransform ) : void {
			_soundTransform = soundTransform;
			SoundMixer.soundTransform = soundTransform;
		}

		public function set volume( volume : Number ) : void {
			_volume = volume;
			if ( !_muted ) {
				_soundTransform.volume = volume;
				SoundMixer.soundTransform = _soundTransform;
			}
		}
	}
}
