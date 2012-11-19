package fabis.wunderreise.games.estimate {
	import flash.events.ProgressEvent;
	import flash.events.ErrorEvent;
	import flash.events.SampleDataEvent;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import flash.display.Sprite;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateExercise extends Sprite implements ISoundItemDelegate {
		
		public var _gameOptions : FabisEstimateGameOptions;
		public var _game : FabisEstimateGame;
		
		protected var _mainView : FabisCristoView;
		protected var _dragContainer : CristoDragContainer;
		protected var _stackField : CristoStackField;
		protected var _doneButton : DoneButton;
		
		protected var _emptyXValues : Array;
		protected var _emptyYValues : Array;
		
		protected var _elementView : *;
		protected var _elementVector : *;
		protected var _pushedX : int;
		protected var _pushedY : int;
		protected var _stackFieldDiffY : int;
		protected var _stackFieldDiffX : int;
		protected var _dragContainerDiffY : int;
		protected var _dragContainerDiffX : int;
		protected var _pushedElementsNumber : int = 0;
		protected var _attempt : int = 1;
		
		protected var _dragedObject : *;
		protected var _dragedObjectX : int;
		protected var _dragedObjectY : int;
		
		protected var _soundCore : ISoundCore;
		
		protected var _buttonClickedSound : ISoundItem;
		protected var _buttonClickedSoundStarted : Boolean = false;
		
		protected var _feedbackSound : ISoundItem;
		public var _feedbackSoundStarted : Boolean = false;
		
		protected var _frameCounter : int = 0;
		
		public function FabisEstimateExercise() {
			
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			_gameOptions.correctItemNumber = 6;
			
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
			
			_emptyXValues = new Array();
			_emptyYValues = new Array();
		}
		
		protected function initDragContainer() : void {
			
			_dragContainer = new CristoDragContainer();
			_gameOptions.dragContainer = _dragContainer;
			_mainView.addChild( _dragContainer );
		}
		
		protected function initStackField() : void {
			_stackField = new CristoStackField();
			_mainView.addChild( _stackField );
		}
		
		protected function initDoneButton() : void {
			_doneButton = new DoneButton();
			_doneButton.x = 745;
			_doneButton.y = 450;
			_mainView.addChild( _doneButton );
		}
		
		public function initDrag() : void {
			for each( _elementView in _elementVector ){
				_elementView.buttonMode = true;
				_elementView.val = 0;
				_elementView.addEventListener( MouseEvent.MOUSE_DOWN, handleDrag );
			}
			activateDoneButton();
		}
		
		protected function handleDrag( event: MouseEvent ) : void {
			_dragedObject = _elementView;
			_dragedObjectX = _elementView.x;
			_dragedObjectY = _elementView.y;
			_elementView.startDrag();
			_dragContainer.stage.addEventListener( MouseEvent.MOUSE_UP, handleDrop );
		}
		
		protected function handleDrop( event: MouseEvent ) : void {
			
			if( hitStackField() && _dragedObject.val == 0 ){
				
				_dragContainer.stage.removeEventListener( MouseEvent.MOUSE_UP, handleDrop );
				_dragedObject.removeEventListener( MouseEvent.MOUSE_DOWN, handleDrag );
				
				_emptyXValues.push( _dragedObjectX );
				_emptyYValues.push( _dragedObjectY );
				
				_dragedObject.stopDrag();
				_dragContainer.removeChild( _dragedObject );
				_stackField.addChild( _dragedObject );
				_dragedObject.addEventListener( MouseEvent.MOUSE_DOWN, handleDrag );
				
				_pushedX += _stackFieldDiffX;
				_pushedY += _stackFieldDiffY;
				_dragedObject.x = _pushedX;
				_dragedObject.y = _pushedY;				
				_dragedObject.val = 1;
				
				_pushedElementsNumber++;				
			}
			else if( hitDragContainer() && _dragedObject.val == 1 ){
				
				_dragContainer.stage.removeEventListener( MouseEvent.MOUSE_UP, handleDrop );
				_dragedObject.removeEventListener( MouseEvent.MOUSE_DOWN, handleDrag );
				
				var _index : int = _stackField.getChildIndex( _dragedObject );
				var _emptyX : int = _emptyXValues.shift();
				var _emptyY : int = _emptyYValues.shift();
				
				_dragedObject.stopDrag();
				_stackField.removeChild( _dragedObject );
				_dragContainer.addChild( _dragedObject );
				_dragedObject.addEventListener( MouseEvent.MOUSE_DOWN, handleDrag );
				
				_dragedObject.x = _emptyX;
				_dragedObject.y = _emptyY;
				_dragedObject.val = 0;
				
				_pushedY -= _stackFieldDiffY;
				_pushedX -= _stackFieldDiffX;
				_pushedElementsNumber--;
				
				elementsShift( _index );
			}
			else{
				_dragedObject.stopDrag();
				_dragedObject.x = _dragedObjectX;
				_dragedObject.y = _dragedObjectY;
			}
		}
		
		protected function elementsShift( childIndex : int ) : void {
		}
		
		
		public function removeStatue() : void {
			_mainView._cristo.visible = false;
		}
		
		public function showStatue() : void {
			_mainView._cristo.visible = true;
		}
		
		private function hitStackField() : Boolean {
			if( mouseX >= _stackField.x && mouseX <= (_stackField.x + _stackField.width) &&
					mouseY >= _stackField.y && mouseY <= (_stackField.y + _stackField.height) ){
				return true;
			}
			return false;
		}
		
		private function hitDragContainer() : Boolean {
			if( mouseX >= _dragContainer.x && mouseX <= (_dragContainer.x + _dragContainer.width) &&
					mouseY >= _dragContainer.y && mouseY <= (_dragContainer.y + _dragContainer.height) ){
				return true;
			}
			return false;
		}
		
		protected function activateDoneButton() : void {
			if ( _doneButton )
				_doneButton.addEventListener( MouseEvent.CLICK, onClickDoneButton );
		}
		
		protected function onClickDoneButton( event: MouseEvent ) : void {
			if( !_game._helpSoundStarted ){
				_doneButton.removeEventListener( MouseEvent.CLICK, onClickDoneButton );
				_buttonClickedSound = soundCore.getSoundByName("buttonClicked");
				_buttonClickedSound.play();
				
				playFeedback( _gameOptions.currentExerciseNumber, _pushedElementsNumber, _attempt );
				_attempt++;
			}
			
		}
		
		public function handleGameInstructions( event : Event ) : void {
		}
		
		public function reset() : void {
			//_pushedElementsNumber = 0;
			_frameCounter = 0;
			
			//_emptyXValues = new Array();
			//_emptyYValues = new Array();
			
			//_mainView.removeChild( _dragContainer );
			//_mainView.removeChild( _stackField );
			
		}
		
		public function clean() : void {
			showStatue();
			_mainView.removeChild( _dragContainer );
			_mainView.removeChild( _stackField );
			_mainView.removeChild( _doneButton );
		}
		
		
		public function set soundCore( soundCore : ISoundCore) : void {
			_soundCore = soundCore;
		}
		
		public function get soundCore() : ISoundCore {
			return _soundCore;
		}
		
		public function playFeedback( exerciseNumber : int, pushedItemsNumber : int, attempt : int ) : void {
			var _tryAgain : Boolean = false;
			
			switch( exerciseNumber ){
				case 1:
					
					if( attempt == 2 ){
						if( pushedItemsNumber == _gameOptions.correctItemNumber )
							_feedbackSound = soundCore.getSoundByName("cristoGiraffesFeedbackRight");
						else
							_feedbackSound = soundCore.getSoundByName("cristoGiraffesFeedbackSecondAttemptWrong");
							
						TweenLite.delayedCall(5, _game._currentExercise.showBar );
					}
					else{
						if( pushedItemsNumber > _gameOptions.correctItemNumber ){
							_feedbackSound = soundCore.getSoundByName("cristoGiraffesFeedbackFirstAttemptTooMuch");
							_tryAgain = true;
						}
						else if( pushedItemsNumber < _gameOptions.correctItemNumber ){
							_feedbackSound = soundCore.getSoundByName("cristoGiraffesFeedbackFirstAttemptTooLittle");
							_tryAgain = true;
						}
						else{
							_feedbackSound = soundCore.getSoundByName("cristoGiraffesFeedbackRight");
							TweenLite.delayedCall(5, _game._currentExercise.showBar );
						}
					}
					break;
					
				case 2:
				
					if( attempt == 2 ){
						if( pushedItemsNumber == _gameOptions.correctItemNumber )
							_feedbackSound = soundCore.getSoundByName("cristoCarsFeedbackRight");
						else
							_feedbackSound = soundCore.getSoundByName("cristoCarsFeedbackSecondAttemptWrong");
						
						TweenLite.delayedCall(1, _game._currentExercise.showBar );
					}
					else{
						if( pushedItemsNumber > _gameOptions.correctItemNumber ){
							_feedbackSound = soundCore.getSoundByName("cristoCarsFeedbackFirstAttemptTooMuch");
							_tryAgain = true;
						}
						else if( pushedItemsNumber < _gameOptions.correctItemNumber ){
							_feedbackSound = soundCore.getSoundByName("cristoCarsFeedbackFirstAttemptTooLittle");
							_tryAgain = true;
						}
						else{
							_feedbackSound = soundCore.getSoundByName("cristoCarsFeedbackRight");
							TweenLite.delayedCall(1, _game._currentExercise.showBar );
						}
					}
					
					break;
			}
			_feedbackSound.delegate = this;
			_feedbackSound.play();
			_feedbackSoundStarted = true;
			_gameOptions.lipSyncher.start();
			_game.secondTry = _tryAgain;
		}
		
		public function showBar() : void {
			showStatue();
		}

		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _feedbackSoundStarted ){
				_gameOptions.lipSyncher.stop();
				_feedbackSoundStarted = false;
				TweenLite.delayedCall( 1, _game.endOfExercise );
			}
		}

		public function reactOnSoundItemLoadComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemErrorEvent(evt : ErrorEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSampleDataEvent(evt : SampleDataEvent, soundItem : ISoundItem) : void {
		}
	}
}
