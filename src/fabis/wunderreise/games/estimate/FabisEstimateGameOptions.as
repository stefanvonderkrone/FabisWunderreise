package fabis.wunderreise.games.estimate {
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGameOptions {
		
		public var game : FabisEstimateGame;
		public var skipButton : FabisSkipButton;
		public var correctItemNumber : int;
		public var exerciseNumber : int;
		public var currentExerciseNumber : int;
		
		public var flipTime : int;
		public var showGiraffesTime : int;
		public var removeStatueTime : int;
		public var showSockelTime : int;
		public var showDoneButtonTime : int;
		
		public var showCarsTime : int;
		public var showRoadSign : int;
		public var removeCarsStatueTime : int;
		
		public var fabiCristoSmallContainer : FabiCristoSmallContainer;
		public var fabiSmall : FabiSmall;
		
		public var fabiCristoContainer : FabiCristoContainer;
		public var fabiCristo : FabiCristo;
		
		public var dragContainer : CristoDragContainer;
		public var giraffes : Vector.<CristoGiraffeView>;
		
		public var lipSyncher : FabisLipSyncher;
		public var eyeTwinkler : FabisEyeTwinkler;
		
		public function FabisEstimateGameOptions(){
			
		}
	}
}
