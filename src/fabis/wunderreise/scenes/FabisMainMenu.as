package fabis.wunderreise.scenes {

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
		
		private static const MOUSE_OUT_FPS : uint = 120;
		private static const MOUSE_OVER_FPS : uint = 90;
		private static const PLAY_HELP_SOUND_DELAY : Number = 30000;
		
		protected var _timedHelpSounds : Vector.<ISoundItem>;
		protected var _timedHeldInterval : uint;

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
			initButton( view._worldMap._chichenItza );
			initButton( view._worldMap._chineseWall );
			initButton( view._worldMap._colosseum );
			initButton( view._worldMap._cristo );
			initButton( view._worldMap._machuPicchu );
			initButton( view._worldMap._petra );
			initButton( view._worldMap._tajMahal );
			super.handleCreation();
		}
		
		override protected function handleClick( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case view._worldMap._chichenItza:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							FabisTravelAnimationTarget.HOME,
							FabisTravelAnimationTarget.CHICHEN_ITZA
						), true
					);
//					gameCore.director.replaceScene( new FabisChichenItzaQuiz(), true );
					break;
				case view._worldMap._chineseWall:
					break;
				case view._worldMap._colosseum:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							FabisTravelAnimationTarget.HOME,
							FabisTravelAnimationTarget.CHINESE_WALL
						), true
					);
//					gameCore.director.replaceScene( new FabisKolosseumWordsCapture(), true );
					break;
				case view._worldMap._cristo:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							FabisTravelAnimationTarget.HOME,
							FabisTravelAnimationTarget.CRISTO
						), true
					);
//					gameCore.director.replaceScene( new FabisCristoEstimate(), true );
					break;
				case view._worldMap._machuPicchu:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							FabisTravelAnimationTarget.HOME,
							FabisTravelAnimationTarget.MACHU_PICCHU
						), true
					);
					break;
				case view._worldMap._petra:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							FabisTravelAnimationTarget.HOME,
							FabisTravelAnimationTarget.PETRA
						), true
					);
//					gameCore.director.replaceScene( new FabisPetraWordsCapture(), true );
					break;
				case view._worldMap._tajMahal:
					gameCore.director.replaceScene(
						new FabisTravelAnimation(
							FabisTravelAnimationTarget.HOME,
							FabisTravelAnimationTarget.TAJ_MAHAL
						), true
					);
//					gameCore.director.replaceScene( new FabisTajMahalMemory(), true );
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
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			var numSounds : int = _timedHelpSounds.length;
			while ( --numSounds >= 0 )
				_timedHelpSounds[ int( numSounds ) ].stop();
			clearInterval( _timedHeldInterval );
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			_timedHeldInterval = setInterval( playHelpSound, PLAY_HELP_SOUND_DELAY );
		}

		protected function playHelpSound() : void {
			_timedHelpSounds[ int( Math.random() * _timedHelpSounds.length ) ].play();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
			_timedHelpSounds = null;
		}
	}
}
