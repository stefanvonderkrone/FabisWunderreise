package com.flashmastery.as3.game.core.sound {

	import com.flashmastery.as3.collections.interfaces.IImmutableList;
	import com.flashmastery.as3.collections.interfaces.ImmutableVector;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class SoundItem extends Object implements ISoundItem {
		
		protected var _created : Boolean;
		protected var _sound : Sound;
		protected var _soundTransform : SoundTransform;
		protected var _volume : Number;
		protected var _soundChannels : Vector.<SoundChannel>;
		protected var _name : String;
		protected var _muted : Boolean;
		protected var _delegate : ISoundItemDelegate;
		protected var _maxNumChannels : int;

		public function SoundItem( sound : Sound ) {
			_sound = sound;
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				_created = true;
				_soundChannels = new Vector.<SoundChannel>();
				_soundTransform = new SoundTransform();
				_volume = 1;
				_maxNumChannels = 1;
				_muted = false;
				handleCreation();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_delegate = null;
				_created = false;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}
		
		protected function updateChannelsBySoundTransform() : void {
			var numChannels : int = _soundChannels.length;
			var channel :SoundChannel;
			while ( --numChannels >= 0 ) {
				channel = _soundChannels[ int( numChannels ) ];
				channel.soundTransform = _soundTransform;
			}
		}
		
		protected function deminishSoundChannelVector() : void {
			var numChannels : int = _soundChannels.length;
			var channel : SoundChannel;
			while ( numChannels > _maxNumChannels ) {
				channel = _soundChannels.shift();
				channel.stop();
				numChannels--;
			}
		}

		public function play( startTime : Number = 0, loops : int = 0, soundTransform : SoundTransform = null ) : void {
			_soundTransform = soundTransform != null ? soundTransform : _soundTransform;
			_soundChannels.push( _sound.play( startTime, loops, _soundTransform ) );
			if ( _soundChannels.length > _maxNumChannels )
				deminishSoundChannelVector();
		}

		public function stop() : void {
			var numChannels : int = _soundChannels.length;
			var channel : SoundChannel;
			while ( --numChannels >= 0 ) {
				channel = _soundChannels.pop();
				channel.stop();
			}
		}

		public function get name() : String {
			return _name;
		}

		public function get sound() : Sound {
			return _sound;
		}

		public function get soundChannels() : IImmutableList {
			const list : ImmutableVector = new ImmutableVector();
			list.setupWithList( _soundChannels );
			return list;
		}

		public function get maxNumChannels() : int {
			return _maxNumChannels;
		}

		public function get bytesLoaded() : uint {
			return _sound.bytesLoaded;
		}

		public function get bytesTotal() : int {
			return _sound.bytesTotal;
		}

		public function get loadProgress() : Number {
			return _sound.bytesTotal > 0 ? _sound.bytesLoaded / _sound.bytesTotal : 0;
		}

		public function get leftPeak() : Number {
			return _soundChannels.length > 0 ? _soundChannels[ _soundChannels.length - 1 ].leftPeak : 1;
		}

		public function get position() : Number {
			return _soundChannels.length > 0 ? _soundChannels[ _soundChannels.length - 1 ].position / 1000 : 0;
		}

		public function get length() : Number {
			return _sound != null ? _sound.length / 1000 : 0;
		}

		public function get rightPeak() : Number {
			return _soundChannels.length > 0 ? _soundChannels[ _soundChannels.length - 1 ].rightPeak : 1;
		}

		public function get soundTransform() : SoundTransform {
			return _soundTransform;
		}

		public function get volume() : Number {
			return _volume;
		}

		public function get muted() : Boolean {
			return _muted;
		}

		public function get delegate() : ISoundItemDelegate {
			return _delegate;
		}

		public function set name( name : String ) : void {
			_name = name;
		}

		public function set soundTransform( soundTransform : SoundTransform ) : void {
			_soundTransform = soundTransform;
			updateChannelsBySoundTransform();
		}

		public function set volume( volume : Number ) : void {
			_volume = volume;
			if ( !_muted ) {
				_soundTransform.volume = _volume;
				updateChannelsBySoundTransform();
			}
		}

		public function set muted( muted : Boolean ) : void {
			_muted = muted;
			_soundTransform.volume = _muted ? 0 : _volume;
			updateChannelsBySoundTransform();
		}

		public function set delegate( delegate : ISoundItemDelegate ) : void {
			_delegate = delegate;
		}

		public function set maxNumChannels( maxNumChannels : int ) : void {
			_maxNumChannels = maxNumChannels;
			if ( _soundChannels.length > _maxNumChannels )
				deminishSoundChannelVector();
		}
	}
}
