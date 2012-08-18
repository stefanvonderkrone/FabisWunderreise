package fabis.wunderreise.scenes {
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
		protected var _skipButton : FabisSkipButton;
		protected var _lipSyncher : FabisLipSyncher;

		public function FabisTajMahalMemory() {
			super();
		}
		
		private function get view() : MemoryTajMahalGameView {
			return MemoryTajMahalGameView( _view );
		}

		override protected function handleCreation() : void {
			_view = new MemoryTajMahalGameView();
			
			_fabi = new FabiView();
			_fabi.x = 50;
			_fabi.y = 270;
			_fabi._arm.gotoAndStop( 1 );
			_fabi._nose.gotoAndStop( 1 );
			_fabi._eyes.gotoAndStop( 1 );
			_fabi._lips.gotoAndStop( 1 );
			view.addChild( _fabi );
			
			_memory = FabisTajMahalGame( view._memoryContainer.addChild( new FabisTajMahalGame() ) );
			const memoryOptions : FabisMemoryGameOptions = new FabisMemoryGameOptions();
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
			
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_memory.soundCore = gameCore.soundCore;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			_memory.start();
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			_memory.stop();
		}
	}
}
