package fabis.wunderreise.games.estimate {
	/**
	 * @author Stefanie Drost
	 */
	public class FabisEstimateGameOptions {
		
		public var game : FabisEstimateGame;
		public var soundManager : FabisEstimateSoundManager;
		public var correctItemNumber : int;
		public var exerciseNumber : int;
		
		public var flipTime : int;
		public var showGiraffesTime : int;
		public var removeStatueTime : int;
		public var showSockelTime : int;
		public var showDoneButtonTime : int;
		
		public var showCarsTime : int;
		public var showRoadSign : int;
		public var removeCarsStatueTime : int;
		
		public var fabiCristoSmallContainer : FabiCristoSmallContainer;
		public var fabiSmall : FabiEstimateSmall;
		
		public var fabiCristoContainer : FabiCristoContainer;
		public var fabi : FabiEstimate;
		
		public var cristoGiraffesDragContainer : CristoGiraffesDragContainer;
		public var giraffes : Vector.<CristoGiraffeView>;
		//public var giraffesGame : FabisEstimateGiraffesGame;
		
		public function FabisEstimateGameOptions(){
			
		}
	}
}