package fabis.wunderreise.games.memory {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisMemoryGameOptions extends Object {
		
		public var numCards : uint = 12;
		public var numColumns : uint = 4;
		public var coverAsset : Class;
		public var cardAssets : Vector.<Class>;
		public var cardWidth : Number = 100;
		public var cardHeight : Number = 100;
		public var gapBetweenCards : int = 10;

		public function FabisMemoryGameOptions() {
		}
	}
}
