package fabis.wunderreise.scenes {

	import flash.events.MouseEvent;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import fabis.wunderreise.sound.IFabisLipSyncherDelegate;

	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisIntro extends BaseScene implements ISoundItemDelegate, IFabisLipSyncherDelegate {
		
		protected static const UPDATE_FRAMES : int = 5;
		protected static const SHOW_SYMBOL_TIME : int = 30;
		protected static const SHOW_PASSPORT_TIME : int = 14;
		protected static const SHOW_MAP_TIME : int = 26;
		protected static const SHOW_HELP_TIME : int = 28;
		protected static const END_INSTRUCTIONS_TIME : int = 31;

		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		protected var _guideSound : ISoundItem;
		protected var _guideSoundStarted : Boolean = false;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _worldmap : FabisWorldMap;
		protected var _symbolArray : Array;
		protected var _menuButtons : FabisMenuButtons;
		protected var _currentMenuSymbol : MovieClip = null;
		
		private var _frameCounter : int = 0;

		public function FabisIntro() {
			super();
		}
		
		private function get view() : FabisIntroView {
			return FabisIntroView( _view );
		}

		override protected function handleCreation() : void {
			_view = new FabisIntroView();
			_menuButtons = new FabisMenuButtons();
			
			_worldmap = _view._map;
			initSymbols();
			
			view._fabi.addEventListener( Event.ENTER_FRAME, showSymbols );
			view._fabi._lips.gotoAndStop( 1 );
			view._fabi._eyes.gotoAndStop( 1 );
			_lipSyncher = new FabisLipSyncher();
			_lipSyncher.delegate = this;
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( view._fabi._eyes );
			
			_symbolArray = [ _worldmap._chichenItza, _worldmap._machuPicchu, _worldmap._cristo, _worldmap._colosseum,
									_worldmap._petra, _worldmap._tajMahal, _worldmap._chineseWall ];
									
			super.handleCreation();
		}

		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_introSound = gameCore.soundCore.getSoundByName( "menuIntro" );
			_introSound.delegate = this;
			_guideSound = gameCore.soundCore.getSoundByName( "menuGuide" );
			_guideSound.delegate = this;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
			_eyeTwinkler.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _eyeTwinkler );
			view._instructionButton.addEventListener( MouseEvent.CLICK, skipToInstructions );
			view._startButton.addEventListener( MouseEvent.CLICK, skipToStart );
		}

		override protected function handleStart() : void {
			super.handleStart();
			_eyeTwinkler.start();
			TweenLite.from(
				view._fabi,
				1, {
					x: -view._fabi.width,
					onComplete: startSound
				}
			);
		}
		
		protected function startSound() : void {
			_introSound.play();
			_introSoundStarted = true;
			_lipSyncher.start();
		}

		override protected function handleStop() : void {
			super.handleStop();
			_introSound.stop();
			TweenLite.killDelayedCallsTo( gameCore.director.replaceScene );
			TweenLite.killTweensOf( view._fabi );
			_lipSyncher.stop();
			_eyeTwinkler.stop();
		}

		override protected function handleDisposal() : void {
			super.handleDisposal();
			_introSound.delegate = null;
			_introSound = null;
			_lipSyncher.gameCore = null;
			_lipSyncher.dispose();
			_eyeTwinkler.gameCore = null;
			_eyeTwinkler.dispose();
		}
		

		public function reactOnSoundItemSoundComplete( soundItem : ISoundItem ) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_lipSyncher.stop();
				startInstructions();
			}
			if( _guideSoundStarted ){
				_guideSoundStarted = false;
				_lipSyncher.stop();
				TweenLite.delayedCall(
					0.5,
					gameCore.director.replaceScene,
					[ new FabisMainMenu(), true ]
				);
			}
			
		}
		
		private function startInstructions() : void {
			_frameCounter = 0;
			_lipSyncher.start();
			_guideSound.play();
			_guideSoundStarted = true;
			view.addChild( _menuButtons );
			_menuButtons._btnHelp.gotoAndStop( 1 );
			_menuButtons._btnMap.gotoAndStop( 1 );
			_menuButtons._btnPassport.gotoAndStop( 1 );
			_menuButtons.addEventListener( Event.ENTER_FRAME, handleMenuInstructions );
		}
		
		private function handleMenuInstructions( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == SHOW_PASSPORT_TIME * 60){
				popUpMenuSymbol( _menuButtons._btnPassport );
			}
			if( _frameCounter == SHOW_MAP_TIME * 60){
				popUpMenuSymbol(  _menuButtons._btnMap );
			}
			if( _frameCounter == SHOW_HELP_TIME * 60){
				popUpMenuSymbol(  _menuButtons._btnHelp );
			}
			if( _frameCounter == END_INSTRUCTIONS_TIME * 60){
				popUpMenuSymbol( null );
				_menuButtons.removeEventListener( Event.ENTER_FRAME, handleMenuInstructions );
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
		
		private function skipToInstructions( event : MouseEvent ) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_introSound.stop();
			}
			if( _guideSoundStarted ){
				_guideSoundStarted = false;
				_guideSound.stop();
			}
			showEachSymbol( _symbolArray );
			view._fabi.removeEventListener( Event.ENTER_FRAME, showSymbols );
			startInstructions();
		}
		
		private function skipToStart(  event : MouseEvent ) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_introSound.stop();
				_lipSyncher.stop();
				_eyeTwinkler.stop();
			}
			if( _guideSoundStarted ){
				_guideSoundStarted = false;
				_guideSound.stop();
				_lipSyncher.stop();
				_eyeTwinkler.stop();
			}
			TweenLite.delayedCall(
				0.5,
				gameCore.director.replaceScene,
				[ new FabisMainMenu(), true ]
			);
		}

		public function reactOnCumulatedSpectrum( cumulatedSpectrum : Number ) : void {
			const lips : MovieClip = view._fabi._lips;
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}
		
		private function initSymbols() : void {
			_worldmap._chichenItza.gotoAndStop( 1 );
			_worldmap._chineseWall.gotoAndStop( 1 );
			_worldmap._colosseum.gotoAndStop( 1 );
			_worldmap._cristo.gotoAndStop( 1 );
			_worldmap._machuPicchu.gotoAndStop( 1 );
			_worldmap._petra.gotoAndStop( 1 );
			_worldmap._tajMahal.gotoAndStop( 1 );
			_worldmap._chichenItza.visible = false;
			_worldmap._chineseWall.visible = false;
			_worldmap._colosseum.visible = false;
			_worldmap._cristo.visible = false;
			_worldmap._machuPicchu.visible = false;
			_worldmap._petra.visible = false;
			_worldmap._tajMahal.visible = false;
		}
		
		private function showSymbols( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == SHOW_SYMBOL_TIME * 60){
				showEachSymbol( _symbolArray );
				view._fabi.removeEventListener( Event.ENTER_FRAME, showSymbols );
			}
		}
		
		private function showEachSymbol( symbols : Array ) : void {
			
			if( symbols.length > 0 ){
				var _symbol : MovieClip = symbols.shift();
				_symbol.visible = true;
				TweenLite.delayedCall( 0.2, showEachSymbol, [ symbols ] );
			}
		}

		public function reactOnSoundItemProgressEvent( evt : ProgressEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemEvent( evt : Event, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemLoadComplete( soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemErrorEvent( evt : ErrorEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnSoundItemSampleDataEvent( evt : SampleDataEvent, soundItem : ISoundItem ) : void {
		}

		public function reactOnStart( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnStop( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnDisposal( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnAddedToDelegater( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnRemovalFromDelegater( delegater : IInteractiveGameObject ) : void {
		}

		public function reactOnGameFinished( result : Object, gameCore : IGameCore ) : void {
		}
	}
}
