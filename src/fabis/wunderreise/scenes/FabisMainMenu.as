package fabis.wunderreise.scenes {
	import com.flashmastery.as3.game.interfaces.core.IGameScene;
	import com.junkbyte.console.Cc;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisMainMenu extends BaseScene {
		
		private static const PLAY_HELP_SOUND_DELAY : Number = 30000;
		protected static const SHOW_PASSPORT_TIME : int = 5;
		protected static const SHOW_MAP_TIME : int = 16;
		protected static const SHOW_HELP_TIME : int = 19;
		
		protected var _timedHelpSounds : Vector.<ISoundItem>;
		protected var _timedHeldInterval : uint;
		protected var _frameCounter : int = 0;
		protected var _currentMenuSymbol : MovieClip = null;
		protected var _storage : *;
		protected var _buttonClickedSound : ISoundItem;

		public function FabisMainMenu() {
			super();
		}
		
		private function get view() : FabisMainMenuView {
			return FabisMainMenuView( _view );
		}

		override protected function handleCreation() : void {
			_view = new FabisMainMenuView();
			
			view._worldMap._chichenItza.gotoAndStop( 1 );
			view._worldMap._chineseWall.gotoAndStop( 1 );
			view._worldMap._colosseum.gotoAndStop( 1 );
			view._worldMap._cristo.gotoAndStop( 1 );
			view._worldMap._machuPicchu.gotoAndStop( 1 );
			view._worldMap._petra.gotoAndStop( 1 );
			view._worldMap._tajMahal.gotoAndStop( 1 );
			view._worldMap._homePic.gotoAndStop( 1 );
			initButton( view._worldMap._chichenItza );
			initButton( view._worldMap._chineseWall );
			initButton( view._worldMap._colosseum );
			initButton( view._worldMap._cristo );
			initButton( view._worldMap._machuPicchu );
			initButton( view._worldMap._petra );
			initButton( view._worldMap._tajMahal );
			initMainMenu( view._menuButtons );
			super.handleCreation();
		}
		
		override protected function handleClick( evt : MouseEvent ) : void {
			_buttonClickedSound = gameCore.soundCore.getSoundByName("buttonClicked");
			_buttonClickedSound.play();
			switch( evt.currentTarget ) {
				case view._worldMap._chichenItza:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.CHICHEN_ITZA
						), true
					);
					break;
				case view._worldMap._chineseWall:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.CHINESE_WALL
						), true
					);
					break;
				case view._worldMap._colosseum:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.COLOSSEUM
						), true
					);
					break;
				case view._worldMap._cristo:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.CRISTO
						), true
					);
					break;
				case view._worldMap._machuPicchu:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.MACHU_PICCHU
						), true
					);
					break;
				case view._worldMap._petra:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.PETRA
						), true
					);
					break;
				case view._worldMap._tajMahal:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							_storage.lastStop,
							FabisTravelAnimationTarget.TAJ_MAHAL
						), true
					);
					break;
				default:
					super.handleClick( evt );
					break;
			}
		}

		override protected function handleMouseOut( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case view._worldMap._chichenItza:
				case view._worldMap._chineseWall:
				case view._worldMap._colosseum:
				case view._worldMap._cristo:
				case view._worldMap._machuPicchu:
				case view._worldMap._petra:
				case view._worldMap._tajMahal:
					const numFrames : uint = MovieClip( evt.currentTarget ).currentFrame;
					TweenLite.to( evt.currentTarget, numFrames / MOUSE_OUT_FPS, { frame: 1 } );
					break;
				default:
					super.handleMouseOut( evt );
					break;
			}
		}

		override protected function handleMouseOver( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case view._worldMap._chichenItza:
				case view._worldMap._chineseWall:
				case view._worldMap._colosseum:
				case view._worldMap._cristo:
				case view._worldMap._machuPicchu:
				case view._worldMap._petra:
				case view._worldMap._tajMahal:
					const mc : MovieClip = MovieClip( evt.currentTarget );
					const numFrames : uint = mc.totalFrames - mc.currentFrame;
					TweenLite.to( evt.currentTarget, numFrames / MOUSE_OVER_FPS, { frame: mc.totalFrames } );
					view._worldMap.setChildIndex( mc, view._worldMap.numChildren - 2 );
					break;
				default:
					super.handleMouseOver( evt );
					break;
			}
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_timedHelpSounds = Vector.<ISoundItem>( [
					_gameCore.soundCore.getSoundByName( "menuTimedHelpA" ),
					_gameCore.soundCore.getSoundByName( "menuTimedHelpB" ),
					_gameCore.soundCore.getSoundByName( "menuTimedHelpWW" )
				] );
			_helpSound = gameCore.soundCore.getSoundByName( "menuHelpHelp" );
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			stopSounds();
			clearInterval( _timedHeldInterval );
		}
		
		protected function stopSounds() : void {
			_helpSound.stop();
			var numSounds : int = _timedHelpSounds.length;
			while ( --numSounds >= 0 )
				_timedHelpSounds[ int( numSounds ) ].stop();
		}
		
		override protected function handleStart() : void {
			_storage = gameCore.localStorage.getStorageObject();
			super.handleStart();
			startTimer();
		}
		
		protected function startTimer() : void {
			_timedHeldInterval = setInterval( playHelpSound, PLAY_HELP_SOUND_DELAY );
		}

		protected function playHelpSound() : void {
			// TODO _timedHelpSounds u.U. null
			_timedHelpSounds[ int( Math.random() * _timedHelpSounds.length ) ].play();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
			_timedHelpSounds = null;
		}

		override protected function handleClickOnHelp() : void {
			clearInterval( _timedHeldInterval );
			TweenLite.killDelayedCallsTo( startTimer );
			TweenLite.delayedCall( _helpSound.length, startTimer );
			stopSounds();
			view.addEventListener( Event.ENTER_FRAME, handleHelpSymbols);
			super.handleClickOnHelp();
		}
		
		protected function handleHelpSymbols( event : Event ) : void {
			_frameCounter++;
			
			if( _frameCounter == SHOW_PASSPORT_TIME * 60 ){
				popUpMenuSymbol( view._menuButtons._btnPassport );
			}
			
			if( _frameCounter == SHOW_MAP_TIME * 60 ){
				popUpMenuSymbol(  view._menuButtons._btnMap );
			}
			
			if( _frameCounter == SHOW_HELP_TIME * 60 ){
				popUpMenuSymbol(  view._menuButtons._btnHelp );
				view.removeEventListener( Event.ENTER_FRAME, handleHelpSymbols );
				TweenLite.delayedCall( 3, removeCurrentSymbol, [ _currentMenuSymbol ]);
			}
		}
		
		private function popUpMenuSymbol( symbol : MovieClip ) : void {
			if( _currentMenuSymbol != null ){
				removeCurrentSymbol( _currentMenuSymbol );
			}
			if( symbol != null ){
				const numFrames : uint = symbol.totalFrames - symbol.currentFrame;
				TweenLite.to( symbol, numFrames / MOUSE_OVER_FPS, { frame: symbol.totalFrames } );
				symbol.parent.setChildIndex( symbol, symbol.parent.numChildren - 1 );
				_currentMenuSymbol = symbol;
			}
		}
		
		private function removeCurrentSymbol( symbol : MovieClip ) : void {
			const numFrames : uint = MovieClip( symbol ).currentFrame;
			TweenLite.to( symbol, numFrames / MOUSE_OUT_FPS, { frame: 1 } );
		}
		
		override protected function handleClickOnPassport() : void {
			super.handleClickOnPassport();
		}
	}
}
