package fabis.wunderreise.gamesave {
	import com.junkbyte.console.Cc;
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisGameSave extends Object {
		
		public var finishedChichenItza : Boolean;
		public var finishedChineseWall : Boolean;
		public var finishedCristoRedentor : Boolean;
		public var finishedColosseum : Boolean;
		public var finishedMachuPicchu : Boolean;
		public var finishedPetra : Boolean;
		public var finishedTajMahal : Boolean;
		
		public var stampArray : Array; 
		public var _stampCounter : int;
		public var currentGameScene : *;
		
		public var lastStop : int;

		public function FabisGameSave() {
			_stampCounter = 0;
			
			finishedChichenItza = false;
			finishedChineseWall = false;
			finishedCristoRedentor= false;
			finishedColosseum = false;
			finishedMachuPicchu = false;
			finishedPetra = false;
			finishedTajMahal = false;
			
			stampArray = [ {"chichenItzaStamp"  :  false },
										{"machuPicchuStamp" : false },
										{"cristoStamp" : false },
										{"colosseumStamp" : false },
										{"petraStamp" : false },
										{"chineseWallStamp" : false },
										{"tajMahalStamp" : false } 
									];
		}
		
		public function toString() : String {
			return "[FabisGameSave:\n"
				+ "\tfinishedChichenItza: " + finishedChichenItza + ",\n"
				+ "\tfinishedChineseWall: " + finishedChineseWall + ",\n"
				+ "\tfinishedCristoRedentor: " + finishedCristoRedentor + ",\n"
				+ "\tfinishedColosseum: " + finishedColosseum + ",\n"
				+ "\tfinishedMachuPicchu: " + finishedMachuPicchu + ",\n"
				+ "\tfinishedPetra: " + finishedPetra + ",\n"
				+ "\tfinishedTajMahal: " + finishedTajMahal + "\n"
				+ "]";
		}
	}
}
