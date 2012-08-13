package fabis.wunderreise.sound {

	import com.flashmastery.as3.game.core.InteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.core.IGameAnimatable;

	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisLipSyncher extends InteractiveGameObject implements IGameAnimatable {
		
		protected var _numFrames : uint = 0;
		protected var _updateFrames : uint = 5;
		protected var _cumulatedSpectrum : Number = 0;
		protected var _spectrum : ByteArray;
		
		public function FabisLipSyncher() {
			super();
		}
		
		protected function get synchDelegate() : IFabisLipSyncherDelegate {
			return (_delegate as IFabisLipSyncherDelegate);
		}
		
		override protected function handleStart() : void {
			
		}

		override protected function handleStop() : void {
			
		}

		override protected function handleDisposal() : void {
			
		}

		override protected function handleCreation() : void {
			_spectrum = new ByteArray();
			_cumulatedSpectrum = 0;
		}

		public function update( deltaTime : Number ) : void {
			if ( !_isRunning ) return;
			_numFrames++;
			SoundMixer.computeSpectrum( _spectrum, false, 0 );
			for (var i:int = 0; i < 512; i++) {
				_cumulatedSpectrum += Math.abs( _spectrum.readFloat() );
			}
			if ( _numFrames == _updateFrames ) {
				if ( synchDelegate )
					synchDelegate.reactOnCumulatedSpectrum( _cumulatedSpectrum );
				_cumulatedSpectrum = 0;
				_numFrames = 0;
			}
		}

		public function get updateFrames() : uint {
			return _updateFrames;
		}

		public function set updateFrames( updateFrames : uint ) : void {
			_updateFrames = updateFrames;
		}

		public function get cumulatedSpectrum() : Number {
			return _cumulatedSpectrum;
		}
	}
}
