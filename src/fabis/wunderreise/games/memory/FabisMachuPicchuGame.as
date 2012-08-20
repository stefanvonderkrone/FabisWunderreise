package fabis.wunderreise.games.memory {
	import flash.events.MouseEvent;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisMachuPicchuGame extends FabisMemoryGame {
		
		public function FabisMachuPicchuGame() {
			
		}
		
		override public function skipIntro( event : MouseEvent ) : void {
			super.skipIntro( event );
		}
		
		override public function start() : void {
			super.start();
			playIntro();
		}
		
		override public function playIntro() : void {
			_introSound = _soundCore.getSoundByName( "machuPicchuIntro" );
			super.playIntro();
		}
		
		override public function playFeedback( cardNumber : int ) : void {
			switch( cardNumber ){
				case 1:
					_feedbackSound = _soundCore.getSoundByName( "machuPicchuImage1" );
					break;
				case 2:
					_feedbackSound = _soundCore.getSoundByName( "machuPicchuImage2" );
					break;
				case 3:
					_feedbackSound = _soundCore.getSoundByName( "machuPicchuImage3" );
					break;
				case 4:
					_feedbackSound = _soundCore.getSoundByName( "machuPicchuImage4" );
					break;
				case 5:
					_feedbackSound = _soundCore.getSoundByName( "machuPicchuImage5" );
					break;
				case 6:
					_feedbackSound = _soundCore.getSoundByName( "machuPicchuImage6" );
					break;
			}
			super.playFeedback( cardNumber );
		}
	}
}
