package fabis.wunderreise.games.wordsCapture.kolosseum {
	
	import com.greensock.TweenLite;
	import flash.utils.getTimer;
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	/**
	 * @author Stefanie Drost
	 */
	public class KolosseumStone extends MovieClip {
		
		// variables
		protected var _randomX : uint;
		protected var _minX : int = 20;
		protected var _maxX : int = 460;
		protected var _id : int;
		public var _bRight : Boolean;
		protected var myGlow : GlowFilter = new GlowFilter();
		protected var _stone : KolosseumStoneView;
		protected var _previousWidth : int;
		protected var _previousHeight : int;
		
		// fall-down values
		protected var _currentSpeed : Number = 0;
		protected static const _gravity : Number = 1.8;
		
		public function KolosseumStone() {
			
		}
		
		public function get stone() : KolosseumStoneView {
			return KolosseumStoneView( _stone );
		}
		
		public function init() : void {
			_stone = new KolosseumStoneView();
			initPosition();
		}
		
		public function initPosition() : void{
			_randomX = Math.floor(Math.random() * (_maxX - _minX + 1)) + _minX;
			stone.x = 330;
			stone.y = 30;
			stone.height = 0;
			stone.width = 0;
			TweenLite.to(stone, 2, {width : 154, height : 100, y : 10});
			TweenLite.to(stone, 2, {x : _randomX});
			_currentSpeed = 0;
		}
		
		public function initFallValues( currentTime : int ) : int{
			
			// "fall-down" values 
			var time : int = getTimer();
			if( !currentTime ) currentTime = time;
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
		
		// highloght right and wrong images
		public function highlight() : void{
			if( bRight ) 
				myGlow.color = 0x33CC33;
			else 
				myGlow.color = 0xFF0000;
			myGlow.blurX = 30;
			myGlow.blurY = 30;
			stone.filters = [myGlow];
			_previousWidth = stone.width;
			_previousHeight = stone.height;
			
			if( stone.parent is BasketFront ){
				stone.parent.setChildIndex( stone, stone.parent.numChildren-1 );
				TweenLite.to( stone, 1, {width: 226, height: 175});
			}
			if( stone.parent is KolosseumGameFieldView ){
				stone.parent.setChildIndex( stone, stone.parent.numChildren-1 );
				TweenLite.to( stone, 1, {y: 350, width: 226, height: 175});
			}
		}
		
		// highloght right and wrong images
		public function removeHighlight() : void{
			myGlow.blurX = 10;
			myGlow.blurY = 10;
			stone.filters = [myGlow];
			if( stone.parent is BasketFront ){
				TweenLite.to( stone, 1, {width: _previousWidth, height: _previousHeight});
			}
			if( stone.parent is KolosseumGameFieldView ){
				stone.parent.setChildIndex( stone, stone.parent.numChildren - stone.parent.numChildren + 3 );
				TweenLite.to( stone, 1, {y: 500, width: _previousWidth, height: _previousHeight});
			}
			
		}
		
		public function remove() : void {
			stone.parent.removeChild( stone );
		}
	}
}
