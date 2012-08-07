package fabis.wunderreise.scenes {

	import fabis.wunderreise.DEBUGGING;

	import com.flashmastery.as3.game.core.GameScene;
	import com.junkbyte.console.Cc;

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class BaseScene extends GameScene {
		
		protected var _buttons : Vector.<InteractiveObject>;
		protected var _btnHelp : MovieClip;
		protected var _btnMap : MovieClip;
		protected var _btnPassport : MovieClip;

		public function BaseScene() {
			_buttons = new Vector.<InteractiveObject>();
			super();
		}
		
		override protected function handleCreation() : void {
			if ( _view == null )
				_view = new Sprite();
			Sprite( _view ).addEventListener( Event.ADDED_TO_STAGE, initView );
			super.handleCreation();
			_name = getQualifiedClassName( this ).split( "::" )[ 1 ];
			log( "scene created!" );
		}
		
		override protected function handleDisposal() : void {
			_btnHelp = null;
			_btnMap = null;
			_btnPassport = null;
			var numButtons : int = _buttons.length;
			while ( --numButtons >= 0 )
				resetButton( _buttons.pop() );
			_buttons = null;
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
			if ( _buttons.indexOf( button ) < 0 )
				_buttons.push( button );
		}
		
		protected function resetButton( button : InteractiveObject ) : void {
			const index : int = _buttons.indexOf( button );
			const sprite : Sprite = button as Sprite;
			if ( sprite ) {
				sprite.mouseChildren = true;
				sprite.useHandCursor = false;
				sprite.buttonMode = false;
			}
			button.removeEventListener( MouseEvent.CLICK, handleClick );
			button.removeEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			button.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );
			if ( index >= 0 )
				_buttons.splice( index, 1 );
		}

		protected function handleMouseOver( evt : MouseEvent ) : void {
		}

		protected function handleMouseOut( evt : MouseEvent ) : void {
		}

		protected function handleClick( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case _btnHelp:
					handleClickOnHelp();
					break;
				case _btnMap:
					handleClickOnMap();
					break;
				case _btnPassport:
					handleClickOnPassport();
					break;
			}
		}

		protected function handleClickOnPassport() : void {
			// TODO handle click on passport
		}

		protected function handleClickOnMap() : void {
			if ( !( this is FabisMainMenu ) )
				gameCore.director.replaceScene( new FabisMainMenu() , true );
		}

		protected function handleClickOnHelp() : void {
			log( "play help sound for specific scene!!!" );
		}
		
		override public function update( deltaTime : Number ) : void {
			deltaTime;
			if ( DEBUGGING && !( this is FabisMainMenu ) && gameCore.keyboardHandler.isKeyPressed( "c" ) )
				gameCore.director.replaceScene( new FabisMainMenu(), true );
		}
		
		protected function log( ...args ) : void {
			if ( !DEBUGGING )
				return;
			Cc.logch.apply( undefined, [ name ].concat( args ) );
		}
		
		protected function initMainMenu( mainMenu : FabisMenuButtons ) : void {
			_btnHelp = mainMenu.hasOwnProperty( "_btnHelp" ) ? mainMenu[ "_btnHelp" ] as MovieClip : null;
			_btnMap = mainMenu.hasOwnProperty( "_btnMap" ) ? mainMenu[ "_btnMap" ] as MovieClip : null;
			_btnPassport = mainMenu.hasOwnProperty( "_btnPassport" ) ? mainMenu[ "_btnPassport" ] as MovieClip : null;
			if ( _btnHelp == null )
				log( "mainMenu has no help (\"_btnHelp\")!!!" );
			else
				initButton( _btnHelp );
			if ( _btnMap == null )
				log( "mainMenu has no map (\"_btnMap\")!!!" );
			else
				initButton( _btnMap );
			if ( _btnPassport == null )
				log( "mainMenu has no passport (\"_btnPassport\")!!!" );
			else
				initButton( _btnPassport );
		}
	}
}
