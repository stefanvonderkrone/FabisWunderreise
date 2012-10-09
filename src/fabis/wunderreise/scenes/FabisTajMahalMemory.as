package fabis.wunderreise.scenes {
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.games.memory.FabisTajMahalGame;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import fabis.wunderreise.games.memory.FabisMemoryGame;
	import fabis.wunderreise.games.memory.FabisMemoryGameOptions;

	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisTajMahalMemory extends BaseScene {
		
		protected var _memory : FabisTajMahalGame;
		protected var _fabi : FabiView;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _storage : *;
		protected var _menuButtons : FabisMenuButtons;
		protected var memoryOptions : FabisMemoryGameOptions;

		public function FabisTajMahalMemory() {
			super();
		}
		
		private function get view() : MemoryTajMahalGameView {
			return MemoryTajMahalGameView( _view );
		}

		override protected function handleCreation() : void {
			_view = new MemoryTajMahalGameView();
			_menuButtons = new FabisMenuButtons();
			_fabi = new FabiView();
			_fabi.x = 50;
			_fabi.y = 270;
			_fabi._arm.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			view.addChild( _fabi );
			
			_memory = FabisTajMahalGame( view._memoryContainer.addChild( new FabisTajMahalGame() ) );
			memoryOptions = new FabisMemoryGameOptions();
			memoryOptions.memoryContainer = view._memoryContainer;
			memoryOptions.cardAssets = Vector.<Class>( [
				MemoryTajMahalCard01,
				MemoryTajMahalCard02,
				MemoryTajMahalCard03,
				MemoryTajMahalCard04,
				MemoryTajMahalCard05,
				MemoryTajMahalCard06
			] );
			memoryOptions.cardHeight = 128;
			memoryOptions.cardWidth = 128;
			memoryOptions.coverAsset = MemoryTajMahalCover;
			memoryOptions.numCards = 12;
			memoryOptions.numColumns = 4;
			memoryOptions.showMemoryTime = 15;
			_memory.initWithOptions( memoryOptions );
			_memory.x = ( 900 - _memory.width ) >> 1;
			_memory.y = ( 600 - _memory.height ) >> 1;
			memoryOptions.fabi = _fabi;
			memoryOptions.memoryGame = _memory;
			
			_lipSyncher = new FabisLipSyncher();
			memoryOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( _fabi._eyes );
			
			_memory._mainView = view;
			view.addChild( _menuButtons );
			initMainMenu( _menuButtons );
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_memory.soundCore = gameCore.soundCore;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
			_eyeTwinkler.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _eyeTwinkler );
		}
		
		override protected function handleStart() : void {
			_storage = gameCore.localStorage.getStorageObject();
			_storage.lastStop = FabisTravelAnimationTarget.TAJ_MAHAL;
			gameCore.localStorage.saveStorage();
			
			if( _storage.stampArray["tajMahalStamp"] ){
				_skipButton = new FabisSkipButton();
				_skipButton.x = 900 - _skipButton.width - 20;
				_skipButton.y = 20;
				memoryOptions.skipButton = _skipButton;
				_skipButton.addEventListener( MouseEvent.CLICK, _memory.skipIntro);
				view.addChild( _skipButton );
				_skipButton.addEventListener( MouseEvent.MOUSE_OVER, highlightButton );
				_skipButton.addEventListener( MouseEvent.MOUSE_OUT, removeButtonHighlight );
				_skipButton.buttonMode = true;
			}
			
			super.handleStart();
			_eyeTwinkler.start();
			_memory.start();
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			_eyeTwinkler.stop();
			_lipSyncher.stop();
			_memory.soundCore.stopAllSounds();
			
			if( _memory._gameFinished ){
				_storage = gameCore.localStorage.getStorageObject();
				
				if( _storage.stampArray["tajMahalStamp"] ){
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
				else{
					_storage.stampArray["tajMahalStamp"] = false;
					_storage.finishedTajMahal = true;
					gameCore.localStorage.saveStorage();
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
			}
		}
		
		override protected function handleClickOnHelp() : void {
			if( !_memory.hasCurrentSound() ){
				memoryOptions.lipSyncher.start();
				_helpSound = gameCore.soundCore.getSoundByName( "menuHelpMemory" );
				_helpSound.delegate = this;
				_memory._helpSoundStarted = true;
				super.handleClickOnHelp();
			}
			
		}
		
		override protected function handleClickOnPassport() : void {
			if( !( this is FabisPassport ) ){
				_storage = gameCore.localStorage.getStorageObject();
				_storage.currentGameScene = gameCore.director.currentScene;
				gameCore.localStorage.saveStorage();
				gameCore.director.pushScene( new FabisPassport() );
			}
		}
		
		override public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _memory._helpSoundStarted ){
				_memory._helpSoundStarted = false;
				memoryOptions.lipSyncher.stop();
			}
		}
	}
}
