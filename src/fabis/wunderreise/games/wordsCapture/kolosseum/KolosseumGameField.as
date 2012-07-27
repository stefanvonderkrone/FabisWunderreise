package fabis.wunderreise.games.wordsCapture.kolosseum {
	
	import fabis.wunderreise.games.wordsCapture.FabisWordsCaptureGameField;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * @author Stefanie Drost
	 */
	public class KolosseumGameField extends FabisWordsCaptureGameField {
				
		public function KolosseumGameField() {
			
		}
		
		public function get gameField() : KolosseumGameFieldView {
			return KolosseumGameFieldView( _gameField );
		}
		
		override public function init() : void {
			_gameField = new KolosseumGameFieldView();
			super._gameField = gameField;
			super._gameFieldObject = this;
			super.init();
		}
		
		override public function startIntro() : void{
			super._stone = new KolosseumStone();
			super.startIntro();			
		}
		
		override public function stopIntro() : void {
			super.stopIntro();
			start();
		}
		
		override public function start() : void {
			
			gameField.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			super._stone = new KolosseumStone();
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
		
		public function getNewStone() : KolosseumStone {
			return new KolosseumStone();
		}
		
		public function removeListener() : void {
			gameField.removeEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			gameField.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			gameField.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			Mouse.show();
		}
	}
}
