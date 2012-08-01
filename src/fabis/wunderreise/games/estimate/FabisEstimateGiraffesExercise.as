package fabis.wunderreise.games.estimate {
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGiraffesExercise extends Sprite{
	
		protected var _mainView : FabisCristoView;
		public var _gameOptions : FabisEstimateGameOptions;
		
		protected var _giraffesDragContainer : CristoGiraffesDragContainer;
		protected var _giraffesSockel : CristoGiraffesSockel;
		protected var _stackField : CristoStackField;
		protected var _doneButton : DoneButton;
		protected var _heightBar : CristoHeightBar;
		protected var _giraffes : Vector.<CristoGiraffeView>;
		
		protected var _pushedGiraffesNumber : int = 0;
		protected var _pushedGiraffeX : int = 70;
		protected var _pushedGiraffeY : int = 392;
		protected var _emptyXValues : Array;
		protected var _emptyYValues : Array;
		
		protected var _dragedObject : CristoGiraffeView;
		protected var _dragedObjectX : int;
		protected var _dragedObjectY : int;
		
		protected var _frameCounter : int = 0;
		protected var _attempt : int = 1;
		
		public function FabisEstimateGiraffesExercise() {
			
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			_gameOptions.correctItemNumber = 6;
			
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
			
			_giraffes = new Vector.<CristoGiraffeView>();
			_emptyXValues = new Array();
			_emptyYValues = new Array();
		}
		
		private function initGiraffesContainer() : void {
			
			_giraffesDragContainer = new CristoGiraffesDragContainer();
			_giraffesDragContainer.x = 750;
			_giraffesDragContainer.y = 0;
			
			_gameOptions.cristoGiraffesDragContainer = _giraffesDragContainer;
			_mainView.addChild( _giraffesDragContainer );
		}
		
		public function initGiraffes() : void {
			
			var _i : int;
			var _y : int = 0;
			var _x : int = 0;
			var _giraffe : CristoGiraffeView;
			
			initGiraffesContainer();
			
			for( _i = 0; _i < 12; _i++ ){
				_giraffe = new CristoGiraffeView();
				_giraffe.width = 40;
				_giraffe.height = 61;
				
				if( _i % 3 == 0 ){
					_y += 78;
					_x = 0;
				}
				else{
					_x += 50;
				}
				_giraffe.x = _x;
				_giraffe.y = _y;
				
				_giraffesDragContainer.addChild( _giraffe );
				_giraffes.push( _giraffe );
			}
		}
		
		public function initGiraffesSockel() : void {
			_giraffesSockel = new CristoGiraffesSockel();
			_giraffesSockel.x = 505;
			_giraffesSockel.y = 405;
			_mainView.addChildAt( _giraffesSockel, 3 );
			initStackField();
		}
		
		private function initStackField() : void {
			_stackField = new CristoStackField();
			_stackField.x = 500;
			_stackField.y = 11;
			_mainView.addChild( _stackField );
		}
		
		public function initDoneButton() : void {
			_doneButton = new DoneButton();
			_doneButton.x = 725;
			_doneButton.y = 450;
			_mainView.addChild( _doneButton );
		}
		
		public function initDrag() : void {
			var _curGiraffe : CristoGiraffeView;
			for each( _curGiraffe in _giraffes ){
				_curGiraffe.buttonMode = true;
				_curGiraffe.val = 0;
				_curGiraffe.addEventListener( MouseEvent.MOUSE_DOWN, handleGiraffeDrag );
			}
			activateDoneButton();
		}
		
		private function activateDoneButton() : void {
			_doneButton.addEventListener( MouseEvent.CLICK, onClickDoneButton );
		}
		
		private function onClickDoneButton( event: MouseEvent ) : void {
			_doneButton.removeEventListener( MouseEvent.CLICK, onClickDoneButton );
			_gameOptions.soundManager.playButtonClicked();
			_gameOptions.soundManager.playFeedback( 1, _pushedGiraffesNumber, _attempt );
			_attempt++;
		}
		
		private function handleGiraffeDrag( event: MouseEvent ) : void {
			var _currentGiraffe : CristoGiraffeView = CristoGiraffeView( event.target );
			_dragedObject = _currentGiraffe;
			_dragedObjectX = _currentGiraffe.x;
			_dragedObjectY = _currentGiraffe.y;
			_currentGiraffe.startDrag();
			_giraffesDragContainer.stage.addEventListener( MouseEvent.MOUSE_UP, handleGiraffeDrop );
		}
		
		private function handleGiraffeDrop( event: MouseEvent ) : void {
			
			if( hitStackField() && _dragedObject.val == 0 ){
				
				_giraffesDragContainer.stage.removeEventListener( MouseEvent.MOUSE_UP, handleGiraffeDrop );
				_dragedObject.removeEventListener( MouseEvent.MOUSE_DOWN, handleGiraffeDrag );
				
				_emptyXValues.push( _dragedObjectX );
				_emptyYValues.push( _dragedObjectY );
				
				_dragedObject.stopDrag();
				_giraffesDragContainer.removeChild( _dragedObject );
				_stackField.addChild( _dragedObject );
				_dragedObject.addEventListener( MouseEvent.MOUSE_DOWN, handleGiraffeDrag );
				_pushedGiraffeY -= 60;
				
				_dragedObject.x = _pushedGiraffeX;
				_dragedObject.y = _pushedGiraffeY;				
				_dragedObject.val = 1;
				
				_pushedGiraffesNumber++;				
			}
			else if( hitGiraffeContainer() && _dragedObject.val == 1 ){
				
				_giraffesDragContainer.stage.removeEventListener( MouseEvent.MOUSE_UP, handleGiraffeDrop );
				_dragedObject.removeEventListener( MouseEvent.MOUSE_DOWN, handleGiraffeDrag );
				
				var _index : int = _stackField.getChildIndex( _dragedObject );
				var _emptyX : int = _emptyXValues.shift();
				var _emptyY : int = _emptyYValues.shift();
				
				_dragedObject.stopDrag();
				_stackField.removeChild( _dragedObject );
				_giraffesDragContainer.addChild( _dragedObject );
				_dragedObject.addEventListener( MouseEvent.MOUSE_DOWN, handleGiraffeDrag );
				
				_dragedObject.x = _emptyX;
				_dragedObject.y = _emptyY;
				_dragedObject.val = 0;
				
				_pushedGiraffeY += 70;
				_pushedGiraffesNumber--;
				
				giraffesFallDown( _index );
			}
			else{
				_dragedObject.stopDrag();
				_dragedObject.x = _dragedObjectX;
				_dragedObject.y = _dragedObjectY;
			}
		}
		
		private function hitStackField() : Boolean {
			if( mouseX >= _stackField.x && mouseX <= (_stackField.x + _stackField.width) &&
					mouseY >= _stackField.y && mouseY <= (_stackField.y + _stackField.height) ){
				return true;
			}
			return false;
		}
		
		private function hitGiraffeContainer() : Boolean {
			if( mouseX >= _giraffesDragContainer.x && mouseX <= (_giraffesDragContainer.x + _giraffesDragContainer.width) &&
					mouseY >= _giraffesDragContainer.y && mouseY <= (_giraffesDragContainer.y + _giraffesDragContainer.height) ){
				return true;
			}
			return false;
		}
		
		private function giraffesFallDown( childIndex : int ) : void {
			var _i : int;
			var _curGiraffe : CristoGiraffeView;
			
			for( _i = childIndex; _i < _stackField.numChildren; _i++ ){
				_curGiraffe = CristoGiraffeView( _stackField.getChildAt( _i ) );
				//_curGiraffe.initY += 70;
				_curGiraffe.y += 70;
			}
		}
		
		public function removeStatue() : void {
			_mainView._cristo.visible = false;
		}
		
		public function showStatue() : void {
			_mainView._cristo.visible = true;
		}
		
		public function handleGameInstructions( event : Event ) : void {
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.showGiraffesTime * 60  ){
				initGiraffes();
			}
			
			if( _frameCounter == _gameOptions.removeStatueTime * 60  ){
				_gameOptions.fabi.flip();
				TweenLite.delayedCall( 1/2 , removeStatue );
			}
			
			if( _frameCounter == _gameOptions.showSockelTime * 60  ){
				initGiraffesSockel();
			}
			
			if( _frameCounter == _gameOptions.showDoneButtonTime * 60  ){
				initDoneButton();
				_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleGameInstructions );
			}
		}
		
		public function reset() : void {
			_pushedGiraffesNumber = 0;
			_pushedGiraffeY = 392;
			_frameCounter = 0;
			
			_giraffes = new Vector.<CristoGiraffeView>();
			_emptyXValues = new Array();
			_emptyYValues = new Array();
			
			_mainView.removeChild( _giraffesDragContainer );
			initGiraffes();
			_mainView.removeChild( _stackField );
			initStackField();
			
			initDrag();
		}
		
		public function clean() : void {
			showStatue();
			_mainView.removeChild( _giraffesSockel );
			_mainView.removeChild( _giraffesDragContainer );
			_mainView.removeChild( _stackField );
			_mainView.removeChild( _doneButton );
			_mainView.removeChild( _heightBar );
		}
		
		public function showHeightBar() : void {
			showStatue();
			_heightBar = new CristoHeightBar();
			_heightBar.x = 100;
			_heightBar.y = 0;
			_mainView.addChild( _heightBar );
		}
	}
}
