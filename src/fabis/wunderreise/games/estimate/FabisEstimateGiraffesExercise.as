package fabis.wunderreise.games.estimate {
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGiraffesExercise extends FabisEstimateExercise {
	
		protected var _giraffesSockel : CristoGiraffesSockel;
		protected var _heightBar : CristoHeightBar;
		protected var _giraffes : Vector.<CristoGiraffeView>;
		
		//protected const STACKFIELD_Y_DIFF : int = 60;
		
		private const DRAGFIELD_WIDTH : int = 160;
		private const DRAGFIELD_HEIGHT : int = 400;
		private const DRAGFIELD_X : int = 900 - DRAGFIELD_WIDTH;
		private const DRAGFIELD_Y : int = 11;
		
		private const GIRAFFE_WIDTH : int = 40;
		private const GIRAFFE_HEIGHT : int = 65;
		private const GIRAFFE_SOCKEL_X : int = 500;
		private const GIRAFFE_SOCKEL_Y : int = 425;
		
		private const STACKFIELD_X : int = 500;
		private const STACKFIELD_Y : int = 11;
		private const STACKFIELD_WIDTH : int = 170;
		private const STACKFIELD_HEIGHT : int = GIRAFFE_SOCKEL_Y - STACKFIELD_Y;
		
		private const DRAGFIELD_FIRST_ELEMENT_X : int = 70;
		private const DRAGFIELD_FIRST_ELEMENT_Y : int = STACKFIELD_HEIGHT;
		
		private const BAR_X : int = 110;
		private const BAR_Y : int = 9;
		
		
		public function FabisEstimateGiraffesExercise() {
			
		}
		
		override public function initWithOptions( options : FabisEstimateGameOptions ) : void {
			super.initWithOptions( options );
			_giraffes = new Vector.<CristoGiraffeView>();
			_pushedX = DRAGFIELD_FIRST_ELEMENT_X;
			_pushedY = DRAGFIELD_FIRST_ELEMENT_Y;
			_gameOptions.correctItemNumber = 6;
		}
		
		override protected function initDragContainer() : void {
			super.initDragContainer();
			_dragContainer.x = DRAGFIELD_X;
			_dragContainer.y = DRAGFIELD_Y;
			_dragContainer._content.width = DRAGFIELD_WIDTH;
			_dragContainer._content.height = DRAGFIELD_HEIGHT;
		}
		
		private function initGiraffes() : void {
			
			var _i : int;
			var _y : int = 0;
			var _x : int = 0;
			
			initDragContainer();
			
			for( _i = 0; _i < 12; _i++ ){
				var _giraffe : CristoGiraffeView = new CristoGiraffeView();
				
				if( _i % 3 == 0 ){
					_y += 78;
					_x = 0;
				}
				else{
					_x += 50;
				}
				
				_giraffe.x = _x;
				_giraffe.y = _y;
				_giraffe.width = GIRAFFE_WIDTH;
				_giraffe.height = GIRAFFE_HEIGHT;
				
				_dragContainer.addChild( _giraffe );
				_giraffes.push( _giraffe );
			}
		}
		
		public function initGiraffesSockel() : void {
			_giraffesSockel = new CristoGiraffesSockel();
			_giraffesSockel.x = GIRAFFE_SOCKEL_X;
			_giraffesSockel.y = GIRAFFE_SOCKEL_Y;
			_mainView.addChildAt( _giraffesSockel, 3 );
			initStackField();
		}
		
		override protected function initStackField() : void {
			super.initStackField();
			_stackField.x = STACKFIELD_X;
			_stackField.y = STACKFIELD_Y;
			_stackField._content.width = STACKFIELD_WIDTH;
			_stackField._content.height = STACKFIELD_HEIGHT;
		}
		
		override public function initDrag() : void {
			_elementView : CristoGiraffeView;
			_elementVector = _giraffes;
			super.initDrag();
		}
		
		override protected function handleDrag( event: MouseEvent ) : void {
			_dragedObject : CristoGiraffeView;
			_elementView : CristoGiraffeView;
			_elementView = CristoGiraffeView( event.target );
			super.handleDrag( event );
		}
		
		override protected function handleDrop( event: MouseEvent ) : void {
			_stackFieldDiffY = -GIRAFFE_HEIGHT;
			_stackFieldDiffX = 0;
			super.handleDrop( event );
		}
		
		override protected function elementsShift( childIndex : int ) : void {
			var _i : int;
			_elementView : CristoGiraffeView;
			
			for( _i = childIndex; _i < _stackField.numChildren; _i++ ){
				_elementView = CristoGiraffeView( _stackField.getChildAt( _i ) );
				_elementView.y += GIRAFFE_HEIGHT;
			}
		}
		
		
		override public function handleGameInstructions( event : Event ) : void {
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
		
		override public function reset() : void {
			super.reset();
			_pushedY = DRAGFIELD_FIRST_ELEMENT_Y;
			_pushedX = DRAGFIELD_FIRST_ELEMENT_X;
			_giraffes = new Vector.<CristoGiraffeView>();
			
			initGiraffes();
			initStackField();
			initDrag();
		}
		
		override public function clean() : void {
			super.clean();
			_mainView.removeChild( _giraffesSockel );
			_mainView.removeChild( _heightBar );
		}
		
		override public function showBar() : void {
			super.showBar();
			_heightBar = new CristoHeightBar();
			_heightBar.x = BAR_X;
			_heightBar.y = BAR_Y;
			_mainView.addChild( _heightBar );
		}
	}
}
