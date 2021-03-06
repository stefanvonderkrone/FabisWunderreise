package fabis.wunderreise.games.memory {
	import flash.display.MovieClip;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
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
		public var showMemoryTime : int;
		public var fabi : FabiView;
		public var lipSyncher : FabisLipSyncher;
		public var skipButton : FabisSkipButton;
		public var memoryContainer : MovieClip;
		public var memoryGame : *;
		

		public function FabisMemoryGameOptions() {
		}
	}
}
