package fabis.wunderreise.games.wordsCapture.petra {
	import com.junkbyte.console.Cc;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
		public var _introSoundStarted : Boolean = false;
		private var _currentFeedbackStone : PetraStone;
		private var _feedbackNumber : int = 0;
		private var _feedbackTimer : Timer;
		private var _demoTimer : Timer;
		protected var _buttonClickedSound : ISoundItem;
		
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
		
		override public function removeAllEventListener() : void {
			removeListener();
			if( _demoTimer ) _demoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDemoTimerComplete); 
			if( _feedbackTimer ) _feedbackTimer.removeEventListener(TimerEvent.TIMER, onTick); 
            if( _feedbackTimer ) _feedbackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			//removeEventListener( Event.ENTER_FRAME, handleDemoStart );	
			//_gameField.removeEventListener( Event.ENTER_FRAME, handleFeedbackSound );
			super.removeAllEventListener();
		}
		
		override public function startIntro() : void{
			_gameOptions.lipSyncher.delegate = this;
			
			gameField.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			super._stone = new PetraStone();
			//super.startIntro();
			playIntro();
			
			
			//_feedbackTime = _gameOptions.demoStartTime;
			_demoTimer = new Timer(1000, _gameOptions.demoStartTime);
			
			// designates listeners for the interval and completion events 
            //_feedbackTimer.addEventListener(TimerEvent.TIMER, onTick); 
            _demoTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDemoTimerComplete); 
			
			// starts the timer ticking 
            _demoTimer.start();
			
			//addEventListener( Event.ENTER_FRAME, handleDemoStart );			
		}
		
		public function onDemoTimerComplete(event:TimerEvent) : void { 
			_demoTimer.stop();
			startDemo();
            Cc.logch.apply( undefined, [ "Demo starten" ] );
        } 
		
		override public function skipIntro() : void{
			_introSound.stop();
			_introSoundStarted = false;
			
			_gameOptions.lipSyncher.stop();
			_buttonClickedSound = _soundCore.getSoundByName("buttonClicked");
			_buttonClickedSound.play();
			
			//_demoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDemoTimerComplete); 
			//removeEventListener( Event.ENTER_FRAME, handleDemoStart );	
			stopIntro();
		}
		
		/*private function handleDemoStart( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == (_gameOptions.demoStartTime * 60) ){
				startDemo();
			}
		}*/
		
		override public function stopIntro() : void {
			_demoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDemoTimerComplete); 
			super.stopIntro();
			start();
		}
		
		override public function start() : void {
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
			TweenLite.delayedCall( 1, addStonesToWall );
			var _addStonesSound : ISoundItem = _soundCore.getSoundByName("wordsCaptureAddStones");
			TweenLite.delayedCall( 1, _addStonesSound.play );
			super.completeGame();
		}
		
		override public function removeBasketFront() : void {
			super.removeBasketFront();
		}
		
		override public function reactOnSoundItemSoundComplete( soundItem : ISoundItem ) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				stopIntro();
				Cc.logch.apply( undefined, [ "Demo stoppen" ] );
			}
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				TweenLite.delayedCall(1, playPointsSound);
			}
			if( _pointsSoundStarted ){
				_pointsSoundStarted = false;
				Cc.logch.apply( undefined, [ "Points Sound Ende: "] );
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
			
			soundCore.stopAllSounds();
			
			_feedbackSound = soundCore.getSoundByName("petraDebriefing");
			_feedbackSound.delegate = this;
			_feedbackSoundStarted = true;
			_feedbackSound.play();
			_gameOptions.lipSyncher.start();
			
			//_feedbackTime = ( _gameOptions.feedbackTimes.shift() - 1 ) * 60;
			_feedbackTime = _gameOptions.feedbackTimes.shift();
			_feedbackTimer = new Timer(1000, 55);
			
			// designates listeners for the interval and completion events 
            _feedbackTimer.addEventListener(TimerEvent.TIMER, onTick); 
            _feedbackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
			
			// starts the timer ticking 
            _feedbackTimer.start();
			//_gameField.addEventListener( Event.ENTER_FRAME, handleFeedbackSound );
			
		}
		
		public function onTick(event:TimerEvent) : void { 
			
			if( event.target.currentCount == _feedbackTime ) {
				Cc.logch.apply( undefined, [ "Zeit getroffen: " + event.target.currentCount + " sek"] );
				
				var _stone : PetraStone;
				if( _currentFeedbackStone ) _currentFeedbackStone.removeHighlight();
				
				//if( _feedbackNumber < _gameOptions.numrightStones ){
					
					//_feedbackNumber++;
					var _stoneId : int;
					_stoneId = _gameOptions.feedbackOrder.shift();
					
					for each( _stone in _gameOptions.allPics){
						if( _stone.id == _stoneId ){
							
							_currentFeedbackStone = _stone;
							_currentFeedbackStone.highlight();
							_feedbackTime = _gameOptions.feedbackTimes.shift();
							break;
						}
					}
				//}
			}
        }
		
		public function onTimerComplete(event:TimerEvent) : void { 
			_feedbackTimer.stop();
			_removeSound = soundCore.getSoundByName("removeWrongStones");
			removeWrongStones();
            Cc.logch.apply( undefined, [ "Timer abgelaufen" ] );
        } 
		
		/*private function handleFeedbackSound( event: Event ) : void {
			
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
							_feedbackTime = ( _gameOptions.feedbackTimes.shift() -1 ) * 60;
							break;
						}
					}
				}
				else{
					_removeSound = soundCore.getSoundByName("removeWrongStones");
					removeWrongStones();
					_gameOptions.gameField.removeEventListener( Event.ENTER_FRAME, handleFeedbackSound );
				}
			}
		}*/
		
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
			Cc.logch.apply( undefined, [ "spielt Points Sound: "] );
		}
		
		/*private function removeWrongHighlights() : void {
			var _stone : PetraStone;
			for each( _stone in _gameOptions.wrongStones ){
				_stone.removeHighlight();
			}
		}*/
		
		override public function reactOnCumulatedSpectrum(cumulatedSpectrum : Number) : void {
			const lips : MovieClip = _gameOptions.fabi._lips;
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}
		
		protected function removeWrongStones() : void {
			var _stone : PetraStone; 
			
			if( _gameOptions.wrongStones.length > 0 ){
				_stone = _gameOptions.wrongStones.shift();
				_stone.highlight();
				TweenLite.delayedCall( 1, _removeSound.play );
				TweenLite.delayedCall( 1, _stone.remove );
				TweenLite.delayedCall( 1.5, removeWrongStones );
			}
		}
	}
}
