package fabis.wunderreise.games.estimate {
	import com.greensock.TweenLite;
	import flash.media.SoundMixer;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.MovieClip;
	/**
	 * @author Stefanie Drost
	 */
	public class FabiEstimate extends MovieClip {
		
		protected var _fabi : FabiCristo;
		protected var _bytes : ByteArray; 
		protected var _frameCounter : int = 0;
		protected var _spec : Number = 0;
		
		public function FabiEstimate() {
			
		}
		
		public function init() : void {
			_fabi = new FabiCristo();
			_fabi.width = 77;
			_fabi.height = 243.15;
			view.gotoAndStop( 1 );
			_bytes = new ByteArray();
		}
		
		public function flip() : void {
			TweenLite.to( view, 1, {frame: view.totalFrames} );
			TweenLite.delayedCall(1, view.gotoAndStop, [1] );
		}
		
		public function startSynchronization() : void {
			addEventListener( Event.ENTER_FRAME, handleSynchronization );
		}
		
		public function stopSynchronization() : void {
			removeEventListener( Event.ENTER_FRAME, handleSynchronization );
			view.gotoAndStop( 1 );
		}
		
		private function handleSynchronization( event : Event ) :void {
			_frameCounter++;
			
			_spec = 0;
			SoundMixer.computeSpectrum( _bytes, false, 0 );
			
			for (var i:int = 0; i < 512; i++) {
				_spec += _bytes.readFloat();
			}
			
			if( _frameCounter % 5 == 0 ){
				if ( _spec > -0.4 ) {
					view._mouth.gotoAndStop( 1 );
				}
				else if( _spec > -0.5 ){
					view._mouth.gotoAndStop( 2 );
	 			}	
				else if( _spec > -0.9 ){
					view._mouth.gotoAndStop( 3 );
	 			}
				else{
					view._mouth.gotoAndStop( 4 );		
				}
			}
		}
		
		public function get view() : FabiCristo {
			return FabiCristo( _fabi );
		}
		
		public function set view( fabi : FabiCristo ) : void {
			_fabi = fabi;
		}
	}
}
