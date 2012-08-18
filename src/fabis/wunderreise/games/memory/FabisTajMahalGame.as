package fabis.wunderreise.games.memory {
	/**
	 * @author Stefanie Drost
	 */
	public class FabisTajMahalGame extends FabisMemoryGame {
		
		public function FabisTajMahalGame() {
			
		}
		
		override public function start() : void {
			super.start();
			playIntro();
		}
		
		override public function playIntro() : void {
			_introSound = _soundCore.getSoundByName( "tajMahalIntro" );
			super.playIntro();
		}
		
		override public function playFeedback( cardNumber : int ) : void {
			switch( cardNumber ){
				case 1:
					_feedbackSound = _soundCore.getSoundByName( "tajMahalImage1" );
					break;
				case 2:
					_feedbackSound = _soundCore.getSoundByName( "tajMahalImage2" );
					break;
				case 3:
					_feedbackSound = _soundCore.getSoundByName( "tajMahalImage3" );
					break;
				case 4:
					_feedbackSound = _soundCore.getSoundByName( "tajMahalImage4" );
					break;
				case 5:
					_feedbackSound = _soundCore.getSoundByName( "tajMahalImage5" );
					break;
				case 6:
					_feedbackSound = _soundCore.getSoundByName( "tajMahalImage6" );
					break;
			}
			super.playFeedback( cardNumber );
		}
	}
}
