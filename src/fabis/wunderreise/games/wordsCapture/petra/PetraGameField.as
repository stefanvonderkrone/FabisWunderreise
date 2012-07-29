package fabis.wunderreise.games.wordsCapture.petra {
	
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameField;
	/**
	 * @author Stefanie Drost
	 */
	public class PetraGameField extends FabisWordsCaptureGameField {
		
		public function PetraGameField() {
			
		}
		
		public function get gameField() : PetraGameFieldView {
			return PetraGameFieldView( _gameField );
		}
		
		override public function init() : void {
			_gameField = new PetraGameFieldView();
			super._gameField = gameField;
			super._gameFieldObject = this;
			super.init();
		}
		
		override public function startIntro() : void{
			gameField.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			super._stone = new PetraStone();
			super.startIntro();			
		}
		
		override public function stopIntro() : void {
			super.stopIntro();
			start();
		}
		
		override public function start() : void {
			//TODO: remove eventlistener and start intro first
			//gameField.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			//gameField.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			super._stone = new PetraStone();
			super.start();
		}
		
		public function handleMouseOver( evt : Event ) : void {
			gameField.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.hide();
		}
		
		public function handleMouseOut( evt : Event ) : void {
			gameField.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.show();
		}
		
		public function handleMouseMove( evt : Event ) : void {
			if( mouseX < (900 - super._basket.basket.width) ){
				_basket.basket.x = mouseX - gameField.parent.x;
			}
		}
		
		public function getNewStone() : PetraStone {
			return new PetraStone();
		}
		
		public function removeListener() : void {
			gameField.removeEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			gameField.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.show();
		}
		
		/*public function addStonesToWall() : void {
			
			var _stone : KolosseumStone;
			var _xCoordinate : int;
			var _yCoordinate : int;
			
			if( _gameOptions.rightStones.length > 0 ){
				
				var _frameNumer : int = (_gameOptions.numrightStones + 2) - _gameOptions.rightStones.length;
				_stone = _gameOptions.rightStones.shift();
				_xCoordinate = _gameOptions.wallXCoordinates.shift() - gameField.parent.x;
				_yCoordinate = _gameOptions.wallYCoordinates.shift();
				
				TweenLite.to( _stone.stone, 1, {x: _xCoordinate, y: _yCoordinate, width: 35, height: 50, rotation: -15});
				TweenLite.delayedCall( 1, _gameOptions.background.gotoAndStop, [ _frameNumer ] );
				TweenLite.delayedCall( 1, gameField.removeChild, [ _stone.stone ] );
				TweenLite.delayedCall( 1, addStonesToWall );
			}
		}*/
		
		override public function completeGame() : void {
			super.completeGame();
			//TweenLite.delayedCall( 1, addStonesToWall );
		}
		
		override public function removeBasketFront() : void {
			super.removeBasketFront();
		}
	}
}
