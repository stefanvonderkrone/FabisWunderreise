package fabis.wunderreise.games.wordsCapture.petra {
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	/**
	 * @author Stefanie Drost
	 */
	public class PetraStone extends MovieClip {
		
		// variables
		protected var _randomX : uint;
		protected var _minX : int = 20;
		protected var _maxX : int = 540;
		protected var _id : int;
		protected var _bRight : Boolean;
		
		protected var _stone : PetraStoneView;
		
		// fall-down values
		protected var _currentSpeed : Number = 0;
		protected static const _gravity : int = 3;
		
		public function PetraStone() {
			
		}
		
		public function get stone() : PetraStoneView {
			return PetraStoneView( _stone );
		}
		
		public function init() : void {
			_stone = new PetraStoneView();
			initPosition();
		}
		
		public function initPosition() : void{
			_randomX = Math.floor(Math.random() * (_maxX - _minX + 1)) + _minX;
			stone.x = this._randomX;
			stone.y = 0 - stone.height;
			_currentSpeed = 0;
		}
		
		public function initFallValues( currentTime : int ) : int{
			
			// "fall-down" values 
			var time : int = getTimer();
			var deltaTime : Number = ( time - currentTime ) / 1000;
			_currentSpeed += _gravity * deltaTime;
			return time;
			
		}
		
		public function fall() : void{
			stone.y += _currentSpeed;
		}
		
		public function fallDemo() : void{
			
			if( stone.y > 430 ){
				initPosition();
				var randomIndex : int = Math.floor(Math.random() * (7 - 0 + 1)) + 0;
				stone.gotoAndStop( randomIndex + 1 );
				_currentSpeed = 0;
			}
			else{
				fall();
			}
		}
		
		// falls down
		public function fallDown() : void{
			while( stone.y < 500 ){
				stone.y++;
				stone.width -= 0.3;
				stone.height -= 0.3;
			}
		}
		
		public function set id( id : int ) : void{
			_id = id;
		}
		
		public function get id() : int{
			return _id;
		}
		
		public function set bRight( boolean : Boolean ) : void{
			_bRight = boolean;
		}
		
		public function get bRight() : Boolean{
			return _bRight;
		}
	}
}
