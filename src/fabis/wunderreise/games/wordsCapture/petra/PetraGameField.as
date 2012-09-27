package fabis.wunderreise.games.wordsCapture.petra {
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameField;
	/**
	 * @author Stefanie Drost
	 */
	public class PetraGameField extends FabisWordsCaptureGameField {
		
		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		private var _currentFeedbackStone : PetraStone;
		private var _feedbackNumber : int = 0;
		
		public function PetraGameField() {
			
		}
		
		public function get gameField() : PetraGameFieldView {
			return PetraGameFieldView( _gameField );
		}
		
		override public function init() : void {
			_gameField = new PetraGameFieldView();
			super._gameField = gameField;
			super._gameFieldObject = this;
			super.init();
		}
		
		override public function startIntro() : void{
			_gameOptions.lipSyncher.delegate = this;
			
			gameField.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			super._stone = new PetraStone();
			//super.startIntro();
			playIntro();
			addEventListener( Event.ENTER_FRAME, handleDemoStart );			
		}
		
		override public function skipIntro() : void{
			_introSound.stop();
			_introSoundStarted = false;
			
			_gameOptions.lipSyncher.stop();
			removeEventListener( Event.ENTER_FRAME, handleDemoStart );	
			stopIntro();
		}
		
		private function handleDemoStart( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == (_gameOptions.demoStartTime * 60) ){
				startDemo();
			}
		}
		
		override public function stopIntro() : void {
			super.stopIntro();
			start();
		}
		
		override public function start() : void {
			//TODO: remove eventlistener and start intro first
			//gameField.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			//gameField.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			super._stone = new PetraStone();
			super.start();
		}
		
		public function handleMouseOver( evt : Event ) : void {
			gameField.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.hide();
		}
		
		public function handleMouseOut( evt : Event ) : void {
			gameField.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.show();
		}
		
		public function handleMouseMove( evt : Event ) : void {
			if( mouseX < (900 - super._basket.basket.width) ){
				_basket.basket.x = mouseX - gameField.parent.x;
			}
		}
		
		public function getNewStone() : PetraStone {
			return new PetraStone();
		}
		
		public function removeListener() : void {
			gameField.removeEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			gameField.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.show();
		}
		
		public function addStonesToWall() : void {
			
			var _stone : PetraStone;
			var _xCoordinate : int;
			var _yCoordinate : int;
			
			if( _gameOptions.rightStones.length > 0 ){
				
				var _frameNumer : int = (_gameOptions.numrightStones + 2) - _gameOptions.rightStones.length;
				_stone = _gameOptions.rightStones.shift();
				_xCoordinate = _gameOptions.wallXCoordinates.shift() - gameField.parent.x;
				_yCoordinate = _gameOptions.wallYCoordinates.shift();
				
				TweenLite.to( _stone.stone, 1, {x: _xCoordinate, y: _yCoordinate, width: 35, height: 50, rotation: -15});
				TweenLite.delayedCall( 1, _gameOptions.background.gotoAndStop, [ _frameNumer ] );
				TweenLite.delayedCall( 1, gameField.removeChild, [ _stone.stone ] );
				TweenLite.delayedCall( 1, addStonesToWall );
			}
		}
		
		override public function completeGame() : void {
			super.completeGame();
			TweenLite.delayedCall( 1, addStonesToWall );
		}
		
		override public function removeBasketFront() : void {
			super.removeBasketFront();
		}
		
		override public function reactOnSoundItemSoundComplete( soundItem : ISoundItem ) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				stopIntro();
			}
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				TweenLite.delayedCall(1, playPointsSound);
			}
			if( _pointsSoundStarted ){
				_pointsSoundStarted = false;
				removeBasketFront();
				_gameOptions.lipSyncher.stop();
			}
			super.reactOnSoundItemSoundComplete( soundItem );
		}
		
		public function playIntro() : void {
			_introSound = soundCore.getSoundByName("petraIntro");
			_introSoundStarted = true;
			_introSound.delegate = this;
			_introSound.play();
			_gameOptions.lipSyncher.start();
		}
		
		public function playFeedback( points : int ) : void {
			_points = points;
			
			_feedbackSound = soundCore.getSoundByName("petraDebriefing");
			_feedbackSound.delegate = this;
			_feedbackSoundStarted = true;
			_feedbackSound.play();
			_gameOptions.lipSyncher.start();
			
			_feedbackTime = _gameOptions.feedbackTimes.shift() * 60;
			
			_gameField.addEventListener( Event.ENTER_FRAME, handleFeedbackSound );
			
		}
		
		private function handleFeedbackSound( event: Event ) : void {
			
			_frameNumber++;
			
			if( _frameNumber == _feedbackTime ){
			
				var _stone : PetraStone;
				if( _currentFeedbackStone ) _currentFeedbackStone.removeHighlight();
				
				if( _feedbackNumber < _gameOptions.numrightStones ){
					
					_feedbackNumber++;
					var _stoneId : int;
					_stoneId = _gameOptions.feedbackOrder.shift();
					
					for each( _stone in _gameOptions.allPics){
						if( _stone.id == _stoneId ){
							
							_currentFeedbackStone = _stone;
							_currentFeedbackStone.highlight();
							_feedbackTime = _gameOptions.feedbackTimes.shift() * 60;
							break;
						}
					}
				}
				else{
					for each( _stone in _gameOptions.wrongStones ){
						_stone.highlight();
					}
					TweenLite.delayedCall(2, removeWrongHighlights);
					_gameOptions.gameField.removeEventListener( Event.ENTER_FRAME, handleFeedbackSound );
				}
			}
		}
		
		protected function playPointsSound() : void {
			
			switch( _points ) {
				case 1:
				case 2:
				case 3:
					_pointsSound = soundCore.getSoundByName("petraFeedback3AndLess");
					break;
				case 4:
					_pointsSound = soundCore.getSoundByName("petraFeedback4");
					break;
				case 5:
					_pointsSound = soundCore.getSoundByName("petraFeedback5");
					break;
				case 6:
					_pointsSound = soundCore.getSoundByName("petraFeedback6");
					break;
				case 7:
					_pointsSound = soundCore.getSoundByName("petraFeedback7");
					break;
				case 8:
					_pointsSound = soundCore.getSoundByName("petraFeedbackComplete");
					break;
			}
			_pointsSoundStarted = true;
			_pointsSound.delegate = this;
			_pointsSound.play();
			_gameOptions.lipSyncher.start();
		}
		
		private function removeWrongHighlights() : void {
			var _stone : PetraStone;
			for each( _stone in _gameOptions.wrongStones ){
				_stone.removeHighlight();
			}
		}
		
		override public function reactOnCumulatedSpectrum(cumulatedSpectrum : Number) : void {
			const lips : MovieClip = _gameOptions.fabi._lips;
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}
	}
}
