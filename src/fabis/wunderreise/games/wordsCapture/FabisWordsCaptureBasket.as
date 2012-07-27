package fabis.wunderreise.games.wordsCapture {
	
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
			_basketFront.y = 100;
			_basketFront.gotoAndStop( 1 );
			basket.parent.addChild( _basketFront );
			
			const numFrames : uint = _basketFront.totalFrames - _basketFront.currentFrame;
			TweenLite.to( _basketFront, numFrames / BASKET_FPS, { frame: _basketFront.totalFrames } );
			TweenLite.delayedCall( numFrames / BASKET_FPS, printStones);
			//printStones();
			
				
			//var gameField :* = parent;
			//gameField.startFeedback();
		}
		
		private function printStones() : void {
			
			var _stone : KolosseumStone;
			var xValue : int = 70;
			var yValue : int = 90;
			var number : int = 0;
			
			for each( _stone in _gameOptions.catched ){
				
				_basketFront.addChild( _stone.stone );
				_stone.stone.x = xValue;
				_stone.stone.y = yValue;
				_stone.stone.width = 80;
				_stone.stone.height = 60;
				_stone.stone.visible = true;
				number++;
				
				if( number == 5 ){
					xValue = 70;
					yValue = 160;
				}
				else{
					xValue += 60;
				}
			}
		}
	}
}
