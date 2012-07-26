package fabis.wunderreise.scenes {

	import fabis.wunderreise.games.memory.FabisMemoryGame;
	import fabis.wunderreise.games.memory.FabisMemoryGameOptions;

	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisTajMahalMemory extends BaseScene {
		
		protected var _memory : FabisMemoryGame;

		public function FabisTajMahalMemory() {
			super();
		}
		
		private function get view() : MemoryTajMahalGameView {
			return MemoryTajMahalGameView( _view );
		}

		override protected function handleCreation() : void {
			_view = new MemoryTajMahalGameView();
			_memory = FabisMemoryGame( view._memoryContainer.addChild( new FabisMemoryGame() ) );
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
			_memory.initWithOptions( memoryOptions );
			_memory.x = ( 900 - _memory.width ) >> 1;
			_memory.y = ( 600 - _memory.height ) >> 1;
			//name = "FabisMachuPicchuMemory";
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
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
