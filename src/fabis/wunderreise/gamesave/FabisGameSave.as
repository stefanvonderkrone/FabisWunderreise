package fabis.wunderreise.gamesave {
	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisGameSave extends Object {
		
		public var finishedChichenItza : Boolean = false;
		public var finishedChineseWall : Boolean = false;
		public var finishedCristoRedentor : Boolean = false;
		public var finishedColosseum : Boolean = false;
		public var finishedMachuPicchu : Boolean = false;
		public var finishedPetra : Boolean = false;
		public var finishedTajMahal : Boolean = false;

		public function FabisGameSave() {
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
