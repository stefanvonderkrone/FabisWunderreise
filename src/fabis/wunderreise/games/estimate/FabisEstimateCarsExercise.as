package fabis.wunderreise.games.estimate {
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateCarsExercise extends FabisEstimateExercise {
		
		private const STACKFIELD_WIDTH : int = 420;
		private const STACKFIELD_HEIGHT : int = 100;
		private const STACKFIELD_X : int = 150;
		private const STACKFIELD_Y : int = 450;
		protected const STACKFIELD_X_DIFF : int = 50;
		
		protected const DRAGFIELD_FIRST_ELEMENT_X : int = -50;
		protected const DRAGFIELD_FIRST_ELEMENT_Y : int = 0;
		private const DRAGFIELD_WIDTH : int = 180;
		private const DRAGFIELD_HEIGHT : int = 400;
		protected const DRAGFIELD_X : int = 750;
		protected const DRAGFIELD_Y : int = 0;
		
		private const CAR_WIDTH : int = 50;
		//private const CAR_HEIGHT : int = 30;
		
		private const BAR_X : int = 150;
		private const BAR_Y : int = 0;
		
		private var _roadSign : CristoCarsRoadSign;
		protected var _cars : Vector.<CristoCarView>;
		protected var _widthBar : CristoWidthBar;
		
		
		public function FabisEstimateCarsExercise() {
			
		}
		
		override public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			super.initWithOptions( options );
			_cars = new Vector.<CristoCarView>();
			_pushedX = DRAGFIELD_FIRST_ELEMENT_X;
			_pushedY = DRAGFIELD_FIRST_ELEMENT_Y;
			_gameOptions.correctItemNumber = 7;
		}
		
		private function initRoadSign() : void {
			_roadSign = new CristoCarsRoadSign();
			_roadSign.x = 100;
			_roadSign.y = 300;
			_mainView.addChild( _roadSign );
		}
		
		private function initCars() : void {
			var _i : int;
			var _y : int = 0;
			var _x : int = 0;
			var _car : CristoCarView;
			
			initDragContainer();
			
			for( _i = 0; _i < 12; _i++ ){
				_car = new CristoCarView();
				/*_car.width = 50;
				_car.height = 30;*/
				
				if( _i % 3 == 0 ){
					_y += 78;
					_x = 0;
				}
				else{
					_x += 50;
				}
				_car.x = _x;
				_car.y = _y;
				
				_dragContainer.addChild( _car );
				_cars.push( _car );
			}
		}
		
		override protected function initDragContainer() : void {
			super.initDragContainer();
			_dragContainer.x = DRAGFIELD_X;
			_dragContainer.y = DRAGFIELD_Y;
			_dragContainer._content.width = DRAGFIELD_WIDTH;
			_dragContainer._content.height = DRAGFIELD_HEIGHT;
		}
		
		override protected function initStackField() : void {
			super.initStackField();
			_stackField.x = STACKFIELD_X;
			_stackField.y = STACKFIELD_Y;
			_stackField._content.width = STACKFIELD_WIDTH;
			_stackField._content.height = STACKFIELD_HEIGHT;
		}
		
		override public function initDrag() : void {
			_elementView : CristoCarView;
			_elementVector = _cars;
			super.initDrag();
		}
		
		override protected function handleDrag( event: MouseEvent ) : void {
			_dragedObject : CristoCarView;
			_elementView : CristoCarView;
			_elementView = CristoCarView( event.target );
			super.handleDrag( event );
		}
		
		override protected function handleDrop( event: MouseEvent ) : void {
			_stackFieldDiffY = 0;
			_stackFieldDiffX = STACKFIELD_X_DIFF;
			super.handleDrop( event );
		}
		
		override protected function elementsShift( childIndex : int ) : void {
			var _i : int;
			var _elementView : CristoCarView;
			
			for( _i = childIndex; _i < _stackField.numChildren; _i++ ){
				_elementView = CristoCarView( _stackField.getChildAt( _i ) );
				_elementView.x -= CAR_WIDTH;
			}
		}
		
		override public function handleGameInstructions( event : Event ) : void {
			_frameCounter++;
			
			if( _frameCounter == _gameOptions.showRoadSign * 60  ){
				initRoadSign();
				initStackField();
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
		
		override public function reset() : void {
			super.reset();
			_pushedY = DRAGFIELD_FIRST_ELEMENT_Y;
			_pushedX = DRAGFIELD_FIRST_ELEMENT_X;
			_cars = new Vector.<CristoCarView>();
			
			initCars();
			initStackField();
			initDrag();
		}
		
		override public function clean() : void {
			super.clean();
		}
		
		override public function showBar() : void {
			super.showBar();
			_widthBar = new CristoWidthBar();
			_widthBar.x = BAR_X;
			_widthBar.y = BAR_Y;
			_mainView.addChild( _widthBar );
		}
	}
}
