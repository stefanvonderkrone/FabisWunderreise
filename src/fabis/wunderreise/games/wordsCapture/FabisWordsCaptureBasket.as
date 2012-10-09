package fabis.wunderreise.games.wordsCapture {
	import fabis.wunderreise.games.wordsCapture.petra.PetraStone;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumGameField;
	import fabis.wunderreise.games.wordsCapture.kolosseum.KolosseumStone;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisWordsCaptureBasket extends MovieClip {
		
		protected var _basket : Basket;
		protected var _basketFront : BasketFront; 
		protected var _leftBorder : int;
		protected var _rightBorder : int;
		public var _gameOptions : FabisWordsCaptureGameOptions;
		protected var _tmpCatched : int = 0;
		
		private static const BASKET_FPS : uint = 20;
		
		public function FabisWordsCaptureBasket() {
			
		}
		
		public function get basket() : Basket {
			return Basket( _basket );
		}
		
		public function init() : void {
			_basket = new Basket();
			basket.gotoAndStop( 1 );
		}
		
		public function hitBasket( leftPoint : int, rightPoint : int) : Boolean{
			_leftBorder = basket.x - 50;
			_rightBorder = basket.x + basket.width + 50;
			if( leftPoint >= _leftBorder && rightPoint <= _rightBorder ){
				return true;
			}
			return false;
		}
		
		public function tweenOut() : void {
			const numFrames : uint = basket.totalFrames - basket.currentFrame;
			TweenLite.to( basket, numFrames / BASKET_FPS, { frame: basket.totalFrames } );
		}
		
		public function showBasketFront(  gameOptions : FabisWordsCaptureGameOptions  ) : void {
			_gameOptions = gameOptions;
			
			_basketFront = new BasketFront();
			_basketFront.x = 100;
			_basketFront.y = 80;
			_basketFront.gotoAndStop( 1 );
			basket.parent.addChild( _basketFront );
			
			const numFrames : uint = _basketFront.totalFrames - _basketFront.currentFrame;
			TweenLite.to( _basketFront, numFrames / BASKET_FPS, { frame: _basketFront.totalFrames } );
			TweenLite.delayedCall( numFrames / BASKET_FPS, printStones);
			//printStones();
			
				
			//var gameField :* = parent;
			//gameField.startFeedback();
		}
		
		public function removeBasketFront() : void {
			
			var _x : int = _basketFront.x;
			var _y : int = _basketFront.y;
			
			const numFrames : uint = _basketFront.totalFrames - 1;
			TweenLite.to( _basketFront, numFrames / BASKET_FPS, { frame: 1 } );
			addStonesToGameField( _x, _y );
			
			
		}
		
		private function addStonesToGameField( x : int, y : int ) : void {
			
			//var _gameField : * = _gameOptions.gameField;
			var _stone : MovieClip;
			
			if( basket.parent is KolosseumGameFieldView ){
				_stone = KolosseumStone( _stone );
			}
			if( basket.parent is PetraGameFieldView ){
				_stone = PetraStone( _stone );
			}
			
			for each( _stone in _gameOptions.catched ){
				if( _stone.bRight ){
					basket.parent.addChild( _stone.stone );
					_stone.stone.x += x;
					_stone.stone.y += y;
				}
			}
			basket.parent.removeChild, [ _basketFront ];
			if( _gameOptions.catched.length > 0 ) 
				stonesFallDown();
			else 
				_gameOptions.gameField.completeGame();
		}
		
		private function printStones() : void {
			var _stone : MovieClip;
			
			if( basket.parent is KolosseumGameFieldView ){
				_stone = KolosseumStone( _stone );
			}
			if( basket.parent is PetraGameFieldView ){
				_stone = PetraStone( _stone );
			}
			
			var xValue : int = 47;
			var yValue : int = 90;
			var number : int = 0;
			
			for each( _stone in _gameOptions.catched ){
				
				_basketFront.addChild( _stone.stone );
				_stone.stone.x = xValue;
				_stone.stone.y = yValue;
				_stone.stone.width = 85;
				_stone.stone.height = 65;
				_stone.stone.visible = true;
				number++;
				
				if( number == 4 ){
					xValue = 47;
					yValue = 160;
				}
				else{
					xValue += 90;
				}
			}
		}
		
		private function stonesFallDown() : void {
			var _stone : MovieClip;
			
			if( basket.parent is KolosseumGameFieldView ){
				_stone = KolosseumStone( _stone );
			}
			if( basket.parent is PetraGameFieldView ){
				_stone = PetraStone( _stone );
			}
			
			if( _tmpCatched < _gameOptions.catched.length ){
				_stone = _gameOptions.catched[ _tmpCatched ];
				TweenLite.to( _stone.stone, 1, { y: 500, width: 124, height: 80} );
				_tmpCatched++;
				TweenLite.delayedCall( (1/10), stonesFallDown);
			}
			else{
				_gameOptions.gameField.completeGame();
				//var _gameField : KolosseumGameField = KolosseumGameField( _gameOptions.gameField );
				//TweenLite.delayedCall( 1, _gameField.completeGame );
			}
		}
	}
}
