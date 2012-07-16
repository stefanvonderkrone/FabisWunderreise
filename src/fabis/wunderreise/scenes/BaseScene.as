package fabis.wunderreise.scenes {

	import flash.events.Event;
	import com.flashmastery.as3.game.core.GameScene;

	import flash.display.Sprite;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class BaseScene extends GameScene {

		public function BaseScene() {
			super();
		}
		
		override protected function handleCreation() : void {
			_view = new Sprite();
			Sprite( _view ).addEventListener( Event.ADDED_TO_STAGE, initView );
			super.handleCreation();
		}

		protected function initView( evt : Event ) : void {
			Sprite( _view ).removeEventListener( Event.ADDED_TO_STAGE, initView );
		}
	}
}
