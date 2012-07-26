package fabis.wunderreise.scenes {

	import flash.utils.getQualifiedClassName;
	import com.flashmastery.as3.game.core.GameScene;
	import com.junkbyte.console.Cc;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class BaseScene extends GameScene {

		public function BaseScene() {
			super();
		}
		
		override protected function handleCreation() : void {
			if ( _view == null )
				_view = new Sprite();
			Sprite( _view ).addEventListener( Event.ADDED_TO_STAGE, initView );
			name = getQualifiedClassName( this ).split( "::" )[ 1 ];
			log( "scene created!" );
			super.handleCreation();
		}

		protected function initView( evt : Event ) : void {
			Sprite( _view ).removeEventListener( Event.ADDED_TO_STAGE, initView );
		}
		
		protected function initButton( button : InteractiveObject ) : void {
			const sprite : Sprite = button as Sprite;
			if ( sprite ) {
				sprite.mouseChildren = false;
				sprite.useHandCursor = true;
				sprite.buttonMode = true;
			}
			button.addEventListener( MouseEvent.CLICK, handleClick );
			button.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			button.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
		}

		protected function handleMouseOver( evt : MouseEvent ) : void {
		}

		protected function handleMouseOut( evt : MouseEvent ) : void {
		}

		protected function handleClick( evt : MouseEvent ) : void {
		}
		
		protected function log( ...args ) : void {
			Cc.logch.apply( undefined, [ name ].concat( args ) );
		}
	}
}
