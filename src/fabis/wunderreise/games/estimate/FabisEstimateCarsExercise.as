package fabis.wunderreise.games.estimate {
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateCarsExercise extends Sprite {
		
		protected var _mainView : FabisCristoView;
		public var _gameOptions : FabisEstimateGameOptions;
		
		protected var _doneButton : DoneButton;
		
		//protected var _cars : Vector.<CristoCarsView>;
		
		protected var _pushedCarsNumber : int = 0;
		protected var _emptyXValues : Array;
		protected var _emptyYValues : Array;
		
		protected var _frameCounter : int = 0;
		
		public function FabisEstimateCarsExercise() {
			
		}
		
		public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			_gameOptions = options;
			_gameOptions.correctItemNumber = 6;
			
			_mainView = FabisCristoView( _gameOptions.fabiCristoContainer.parent );
			
			//_cars = new Vector.<CristoCarsView>();
			//_emptyXValues = new Array();
			//_emptyYValues = new Array();
		}
		
		private function initRoadSign() : void {
			
		}
		
		private function initCars() : void {
			
		}
		
		private function initDoneButton() : void {
			_doneButton = new DoneButton();
			_doneButton.x = 725;
			_doneButton.y = 450;
			_mainView.addChild( _doneButton );
		}
		
		public function removeStatue() : void {
			var _cristo : MovieClip = _mainView._cristo;
			_gameOptions.fabiCristoContainer.parent.removeChild( _cristo );
		}
		
		public function handleGameInstructions( event : Event ) : void {
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.showRoadSign * 60  ){
				initRoadSign();
			}
			
			if( _frameCounter == _gameOptions.showCarsTime * 60  ){
				initCars();
				initDoneButton();
			}
			
			if( _frameCounter == _gameOptions.removeCarsStatueTime * 60  ){
				_gameOptions.fabi.flip();
				TweenLite.delayedCall(1, removeStatue );
			}
		}
	}
}
