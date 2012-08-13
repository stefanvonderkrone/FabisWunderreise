package fabis.wunderreise.games.quiz {
	import flash.events.MouseEvent;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisChineseWallQuizGame extends FabisQuizGame {
	
		public function FabisChineseWallQuizGame() {
			
		}
		
		override public function initWithOptions( options : FabisQuizGameOptions ) : void {
			super.initWithOptions( options );
			_game = this;
		}
		
		override public function skipIntro( event : MouseEvent ) : void {
			_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
			_gameOptions.view._chineseWallContainer.removeChild( _gameOptions.skipButton );
			super.skipIntro( event );
		}
		
		override public function start() : void {
			startIntro();
		}
		
		override public function startIntro() : void {
			_introSound = _soundCore.getSoundByName( "chineseWallIntro" );
			super.startIntro();
		}
		
		override public function switchToCloseView() : void {
			_gameOptions.view.removeChild( _gameOptions.view._chineseWallContainer );
			super.switchToCloseView();
		}
		
		override public function initImageContainer( frameNumber : int ) : void {
			
			if( frameNumber == 1 ){
				_imageContainer = new FabisChineseWallImageContainer();
				_rightSymbol = new RightSymbolView();
				_wrongSymbol = new WrongSymbolView();
				_rightSymbol.y = 15;
				_rightSymbol.x = 60;
				_wrongSymbol.y = 15;
				_wrongSymbol.x = 60;
				_imageContainer.x = 350;
				_imageContainer.y = 30;
				_imageContainer.addChild( _rightSymbol );
				_imageContainer.addChild( _wrongSymbol );
				
				view._closeContainer.addChild( _imageContainer );
				
			}
			_imageContainer.gotoAndStop( frameNumber );
		}
		
		override public function playQuestion( questionNumber : int ) : void {
			
			switch( questionNumber ) {
				case 1 :
					_questionSound = _soundCore.getSoundByName( "chineseWallStory1" );
					break;
				case 2 :
					_questionSound = _soundCore.getSoundByName( "chineseWallStory2" );
					break;
				case 3 :
					_questionSound = _soundCore.getSoundByName( "chineseWallStory3" );
					break;
			}
			super.playQuestion( questionNumber );
		}
		
		override public function playFeedback( answerTrue : int, choosedAnswerTrue : Boolean, questionNumber : int ) : void {
			
			switch( questionNumber ){
				case 1:
				
					if( !answerTrue && !choosedAnswerTrue)
						_feedbackSound = _soundCore.getSoundByName( "chineseWallStory1Right" );
					else
						_feedbackSound = _soundCore.getSoundByName( "chineseWallStory1Wrong" );
					break;
					
				case 2:
				
					if( answerTrue && choosedAnswerTrue)
						_feedbackSound = _soundCore.getSoundByName( "chineseWallStory2Right" );
					else
						_feedbackSound = _soundCore.getSoundByName( "chineseWallStory2Wrong" );
					break;
					
				case 3:
				
					if( answerTrue && choosedAnswerTrue)
						_feedbackSound = _soundCore.getSoundByName( "chineseWallStory3Right" );
					else
						_feedbackSound = _soundCore.getSoundByName( "chineseWallStory3Wrong" );
					break;
			}
			
			super.playFeedback( answerTrue, choosedAnswerTrue, questionNumber );
		}
	}
}
