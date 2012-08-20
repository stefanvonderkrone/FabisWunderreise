package fabis.wunderreise.games.quiz {
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisQuizGameOptions {
		
		public var view : *;
		public var fabi : FabiView;
		public var fabiClose : FabiClose;
		
		public var switchTime : int;
		public var questionNumber : int;
		
		public var answers : Array;
		
		public var trueButtonStartTime : int;
		public var skipButton : FabisSkipButton;
		
		public var lipSyncher : FabisLipSyncher;
		public var eyeTwinkler : FabisEyeTwinkler;
	}
}
