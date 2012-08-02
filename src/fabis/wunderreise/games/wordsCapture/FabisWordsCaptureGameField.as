package fabis.wunderreise.games.wordsCapture {
	import com.greensock.TweenLite;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisWordsCaptureGameField  extends MovieClip {
		
		//protected var _gameField : GameField;
		
		protected var _basket : FabisWordsCaptureBasket;
		public var _gameOptions : FabisWordsCaptureGameOptions;
		protected var _gameField :*;
		protected var _gameFieldObject :*;
		protected var _stone :*;
		protected var _frameCounter : int = 0;
		
		
		protected var _currentImageIndex : int;
		protected var _points : int = 0;
		
		// fall-down values
		protected var _currentTime : int;
		
		// constructor
		public function FabisWordsCaptureGameField() {
			
		}
		
		public function init() : void {
			_basket = new FabisWordsCaptureBasket();
			_basket.init();
			_basket.basket.x = 0;
			_basket.basket.y = _gameField.height - 130;
			_gameField.addChild( _basket.basket );
		}
		
		public function startIntro() : void{
			_gameOptions.soundManager.playIntro();
			addEventListener( Event.ENTER_FRAME, handleDemoStart );
		}
		
		private function handleDemoStart( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == (_gameOptions.demoStartTime * 60) ){
				startDemo();
			}
		}
		
		private function startDemo() : void {
			removeEventListener( Event.ENTER_FRAME, handleDemoStart );
			_stone.init();
			_stone.stone.gotoAndStop( _currentImageIndex + 1 );
			_gameField.addChild( _stone.stone );
			_gameField.swapChildren( _stone.stone, _basket.basket );
			
			_gameField.addEventListener(Event.ENTER_FRAME, handleEnterFrameDemo);
		}
		
		public function handleEnterFrameDemo( evt : Event ) : void{
			_currentTime = _stone.initFallValues( _currentTime );
			_stone.fallDemo();
		}
		
		public function stopIntro() : void {
			if ( _stone && _stone.stone )
				_gameField.removeChild( _stone.stone );
			_gameField.removeEventListener(Event.ENTER_FRAME, handleEnterFrameDemo);
		}
		
		public function start() : void {
			
			_stone.init();
			_currentImageIndex = _gameOptions.frameArray.shift();
			_stone.id = _currentImageIndex + 1;
			_stone.stone.gotoAndStop( _currentImageIndex + 1 );
			_gameField.addChild( _stone.stone );
			_gameField.swapChildren( _stone.stone, _basket.basket );
			
			_gameField.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
		}	
		
		public function handleEnterFrame( evt : Event ) : void{
			
			_currentTime = _stone.initFallValues( _currentTime );
			
			// gefangen
			if( _stone.stone.y > 430 && _basket.hitBasket( _stone.stone.x, _stone.stone.x + _stone.stone.width) ){
				
				_gameOptions.soundManager.playStoneCatchedSound();
				checkImage(true);
				_gameOptions.catched.push( _stone );
				_gameOptions.allPics.push( _stone );
				_gameField.removeChild( _stone.stone );
				
				_stone = _gameFieldObject.getNewStone();
				//_stone = new KolosseumStone();
				_stone.init();
				checkGameEnd();
				_stone.id = _currentImageIndex + 1;
				
				
				_gameField.addChild( _stone.stone );
				_gameField.swapChildren( _stone.stone, _basket.basket );
				
			} // vorbei
			else if( _stone.stone.y > 430 && (!_basket.hitBasket( _stone.stone.x, _stone.stone.x + _stone.stone.width)) ){
				
				_gameOptions.soundManager.playStoneFallSound();
				checkImage(false);	
				_gameOptions.allPics.push(this._stone);
							
				_stone.fallDown();
				
				_stone = _gameFieldObject.getNewStone();
				//_stone = new KolosseumStone();
				_stone.init();
				checkGameEnd();
				_stone.id = _currentImageIndex + 1 ;
								
				_gameField.addChild( _stone.stone );
				_gameField.swapChildren( _stone.stone, _basket.basket );
			}
			else{
				_stone.fall();
			}
		}	
		
		//identify wrong and right pics
		public function checkImage( getroffen : Boolean ) : void{
			
			if( _gameOptions.rightPics.indexOf( _stone.id ) != -1 ){
				_stone.bRight = true;
				
				if( getroffen ){
					//TODO: Audio-Ausgabe Punkte
					_points++;
				}
				_gameOptions.rightStones.push( _stone );
			}
			else if( _gameOptions.wrongPics.indexOf( _stone.id ) != -1 ){
				_stone.bRight = false;
				if( !getroffen ){
					//TODO: Audio-Ausgabe Punkte
					_points++;
				}
				_gameOptions.wrongStones.push( _stone );
			}
		}
		
		//remove container if game is done
		public function checkGameEnd() : void{
			if( _gameOptions.frameArray.length == 0 ){
				_gameField.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				_gameFieldObject.removeListener();
				_stone.stone.visible = false;
				showFeedback();
			}
			else{
				_currentImageIndex = _gameOptions.frameArray.shift();
				_stone.stone.gotoAndStop( _currentImageIndex + 1 );
			}
		}
		
		public function showFeedback() : void{
			_basket.tweenOut();
			_basket.showBasketFront( _gameOptions );
			// TODO: add to game
			_gameOptions.soundManager.playFeedback( _points );
			//TweenLite.delayedCall(2, _basket.removeBasketFront );
			//_gameOptions.soundManager.playCompletion();
			//addStonesToWall();
		}
		
		public function removeBasketFront() : void {
			_basket.removeBasketFront();
		}
		
		public function completeGame() : void {
			_gameOptions.soundManager.playCompletion();
		}
	}
}
