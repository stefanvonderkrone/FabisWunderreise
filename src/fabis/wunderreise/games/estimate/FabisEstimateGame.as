package fabis.wunderreise.games.estimate {
	import com.greensock.TweenLite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGame extends Sprite {
		
		protected var _mainView : FabisCristoView;
		protected var _gameOptions : FabisEstimateGameOptions;
		protected var _soundManager : FabisEstimateSoundManager;
		protected var _fabi : FabiEstimate;
		protected var _currentExerciseNumber : int = 1;
		protected var _giraffesDragContainer : CristoGiraffesDragContainer;
		protected var _stackField : CristoStackField;
		protected var _doneButton : DoneButton;
		protected var _giraffes : Vector.<CristoGiraffeView>;
		
		protected var _dragedObject : CristoGiraffeView;
		protected var _dragedObjectX : int;
		protected var _dragedObjectY : int;
		protected var _pushedGiraffesNumber : int = 0;
		protected var _pushedGiraffeX : int = 70;
		protected var _pushedGiraffeY : int = 397;
		protected var _emptyXValues : Array;
		protected var _emptyYValues : Array;
		
		
		public function FabisEstimateGame() {
			
		}
		
		
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			
			_giraffes = new Vector.<CristoGiraffeView>();
			_emptyXValues = new Array();
			_emptyYValues = new Array();
			
			_soundManager = new FabisEstimateSoundManager();
			_soundManager.initWithOptions( _gameOptions );
			_soundManager._game = this;
			
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
		}
		
		public function initFabi() : void {
			_fabi = new FabiEstimate();
			_fabi.init();
			_gameOptions.fabi = _fabi;
			_gameOptions.fabiCristoContainer.addChild( _fabi.view );
			
			startExercise( _currentExerciseNumber );
		}
		
		public function startExercise( exerciseNumber : int ) : void {
			_fabi.startSynchronization();
			_soundManager.playExercise( exerciseNumber );
		}
		
		public function removeStatue() : void {
			var _cristo : MovieClip = _mainView._cristo;
			_gameOptions.fabiCristoContainer.parent.removeChild( _cristo );
		}
		
		public function initGiraffes() : void {
			
			var _i : int;
			var _y : int = -50;
			var _x : int = 0;
			var _giraffe : CristoGiraffeView;
			
			initGiraffesContainer();
			
			for( _i = 0; _i < 10; _i++ ){
				_giraffe = new CristoGiraffeView();
				_giraffe.width = 50;
				_giraffe.height = 76;
				
				if( _i % 2 == 0 ){
					_y += 78;
					_x = 0;
				}
				else{
					_x += 70;
				}
				_giraffe.x = _x;
				_giraffe.InitX = _x;
				_giraffe.y = _y;
				_giraffe.InitY =_y;
				
				_giraffesDragContainer.addChild( _giraffe );
				_giraffes.push( _giraffe );
				
			}
		}
		
		public function initDrag() : void {
			var _curGiraffe : CristoGiraffeView;
			for each( _curGiraffe in _giraffes ){
				_curGiraffe.buttonMode = true;
				_curGiraffe.val = 0;
				_curGiraffe.addEventListener( MouseEvent.MOUSE_DOWN, handleGiraffeDrag );
			}
    		_giraffesDragContainer.stage.addEventListener( MouseEvent.MOUSE_UP, handleGiraffeDrop );
		}
		
		private function handleGiraffeDrag( event: MouseEvent ) : void {
			var _currentGiraffe : CristoGiraffeView = CristoGiraffeView( event.target );
			_dragedObject = _currentGiraffe;
			_dragedObjectX = _currentGiraffe.InitX;
			_dragedObjectY = _currentGiraffe.InitY;
			_currentGiraffe.startDrag();
			//_currentGiraffe.stage.addEventListener( MouseEvent.MOUSE_UP, handleGiraffeDrop );
		}
		
		private function handleGiraffeDrop( event: MouseEvent ) : void {
			
			_dragedObject.stopDrag();
			
			if( hitStackField() && _dragedObject.val == 0 ){
				
				_emptyXValues.push( _dragedObjectX );
				_emptyYValues.push( _dragedObjectY );
				
				_giraffesDragContainer.removeChild( _dragedObject );
				_stackField.addChild( _dragedObject );
				_pushedGiraffeY -= 70;
				
				_dragedObject.x = _pushedGiraffeX;
				_dragedObject.InitX = _pushedGiraffeX;
				_dragedObject.y = _pushedGiraffeY;
				_dragedObject.InitY = _pushedGiraffeY;				
				_dragedObject.val = 1;
				
				_pushedGiraffesNumber++;				
			}
			else if( hitGiraffeContainer() && _dragedObject.val == 1 ){
				
				var _index : int = _stackField.getChildIndex( _dragedObject );
				var _emptyX : int = _emptyXValues.shift();
				var _emptyY : int = _emptyYValues.shift();
				
				_stackField.removeChild( _dragedObject );
				_giraffesDragContainer.addChild( _dragedObject );
				
				_dragedObject.x = _emptyX;
				_dragedObject.initX = _emptyX;
				_dragedObject.y = _emptyY;
				_dragedObject.initY = _emptyY;
				_dragedObject.val = 0;
				
				_pushedGiraffeY += 70;
				_pushedGiraffesNumber--;
				
				giraffesFallDown( _index );
			}
			else{
				_dragedObject.x = _dragedObjectX;
				_dragedObject.y = _dragedObjectY;
			}
		}
		
		private function giraffesFallDown( childIndex : int ) : void {
			var _i : int;
			var _curGiraffe : CristoGiraffeView;
			
			for( _i = childIndex; _i < _stackField.numChildren; _i++ ){
				_curGiraffe = CristoGiraffeView( _stackField.getChildAt( _i ) );
				_curGiraffe.initY += 70;
				_curGiraffe.y += 70;
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
		
		private function initGiraffesContainer() : void {
			
			_giraffesDragContainer = new CristoGiraffesDragContainer();
			_giraffesDragContainer.x = 750;
			_giraffesDragContainer.y = 0;
			
			_gameOptions.cristoGiraffesDragContainer = _giraffesDragContainer;
			_mainView.addChild( _giraffesDragContainer );
		}
		
		public function initGiraffesSockel() : void {
			var _giraffesSockel : CristoGiraffesSockel = new CristoGiraffesSockel();
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
		
		public function start() : void {
			//TODO: add intro
			//startIntro();
			_mainView.removeChild( _gameOptions.fabiCristoSmallContainer );
			initFabi();
		}
		
		public function stop() : void {
			//_gameField.stop();
		}
		
		
		public function startIntro() : void {
			_soundManager.playIntro();
		}
	}
}
