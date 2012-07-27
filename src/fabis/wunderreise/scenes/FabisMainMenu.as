package fabis.wunderreise.scenes {

	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisMainMenu extends BaseScene {
		
		private static const MOUSE_OUT_FPS : uint = 120;
		private static const MOUSE_OVER_FPS : uint = 90;

		public function FabisMainMenu() {
			super();
		}
		
		private function get view() : FabisMainMenuView {
			return FabisMainMenuView( _view );
		}

		override protected function handleCreation() : void {
			_view = new FabisMainMenuView();
			view._chichenItza.gotoAndStop( 1 );
			view._chineseWall.gotoAndStop( 1 );
			view._colosseum.gotoAndStop( 1 );
			view._cristo.gotoAndStop( 1 );
			view._machuPicchu.gotoAndStop( 1 );
			view._petra.gotoAndStop( 1 );
			view._tajMahal.gotoAndStop( 1 );
			initButton( view._chichenItza );
			initButton( view._chineseWall );
			initButton( view._colosseum );
			initButton( view._cristo );
			initButton( view._machuPicchu );
			initButton( view._petra );
			initButton( view._tajMahal );
			name = "FabisMainMenu";
			super.handleCreation();
		}
		
		override protected function handleClick( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case view._chichenItza:
					break;
				case view._chineseWall:
					break;
				case view._colosseum:
					gameCore.director.replaceScene( new FabisKolosseumWordsCapture(), true );
					break;
				case view._cristo:
					break;
				case view._machuPicchu:
					gameCore.director.replaceScene( new FabisMachuPicchuMemory(), true );
					break;
				case view._petra:
					gameCore.director.replaceScene( new FabisPetraWordsCapture(), true );
					break;
				case view._tajMahal:
					break;
			}
		}

		override protected function handleMouseOut( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case view._chichenItza:
				case view._chineseWall:
				case view._colosseum:
				case view._cristo:
				case view._machuPicchu:
				case view._petra:
				case view._tajMahal:
					const numFrames : uint = MovieClip( evt.currentTarget ).currentFrame;
					TweenLite.to( evt.currentTarget, numFrames / MOUSE_OUT_FPS, { frame: 1 } );
					break;
				default:
					break;
			}
		}

		override protected function handleMouseOver( evt : MouseEvent ) : void {
			switch( evt.currentTarget ) {
				case view._chichenItza:
				case view._chineseWall:
				case view._colosseum:
				case view._cristo:
				case view._machuPicchu:
				case view._petra:
				case view._tajMahal:
					const mc : MovieClip = MovieClip( evt.currentTarget );
					const numFrames : uint = mc.totalFrames - mc.currentFrame;
					TweenLite.to( evt.currentTarget, numFrames / MOUSE_OVER_FPS, { frame: mc.totalFrames } );
					view.setChildIndex( mc, view.numChildren - 2 );
					break;
				default:
					break;
			}
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
		}
		
		override protected function handleStop() : void {
			super.handleStop();
		}
		
		override protected function handleStart() : void {
			super.handleStart();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
	}
}
