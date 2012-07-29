package fabis.wunderreise.games.quiz {
	import flash.media.SoundMixer;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.MovieClip;
	/**
	 * @author Stefanie Drost
	 */
	public class FabiQuiz extends MovieClip {
		
		protected var _fabi : FabiView;
		protected var _bytes : ByteArray; 
		protected var _frameCounter : int = 0;
		protected var _spec : Number = 0;
		
		public function FabiQuiz() {
			
		}
		
		public function init() : void {
			view.gotoAndStop( 1 );
			_bytes = new ByteArray();
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
					view.gotoAndStop( 1 );
				}
				else if( _spec > -0.5 ){
					view.gotoAndStop( 2 );
	 			}	
				else if( _spec > -0.9 ){
					view.gotoAndStop( 3 );
	 			}
				else{
					view.gotoAndStop( 4 );		
				}
			}
		}
		
		public function get view() : FabiView {
			return FabiView( _fabi );
		}
		
		public function set view( fabi : FabiView ) : void {
			_fabi = fabi;
		}
	}
}
