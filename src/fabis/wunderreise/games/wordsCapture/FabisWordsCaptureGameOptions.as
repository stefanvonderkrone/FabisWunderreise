package fabis.wunderreise.games.wordsCapture {
	import flash.display.MovieClip;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisWordsCaptureGameOptions extends Object{
	
		public var numStones : uint = 8;
		public var numrightStones : uint = 5;
		public var gameField : FabisWordsCaptureGameField;
		public var background : MovieClip;
		
		public var catched : *;
		public var frameArray : Array = new Array( numStones );
		
		public var wrongPics : Array;
		public var rightPics : Array;
		public var allPics : *;
		public var wrongStones : *;
		public var rightStones : *;
		public var feedbackOrder : Array;
		public var feedbackTimes : Array;
		public var wallXCoordinates : Array;
		public var wallYCoordinates : Array;
		
		public var soundManager : *;
		
		

		public function FabisWordsCaptureGameOptions() {
		}
		
		// creates random frame array
		public function initFrameArray() : Array{
			var i : int;
			for( i = 0; i < frameArray.length; i++ ){
				frameArray[i] = i;
			}
			
			return shuffleList( frameArray );
		}
		
		// Elemente im Array durcheinander wuerfeln
		public function shuffleList( array : Array ) : Array {
			var i : int = 0;
			var numElements : int = array.length;
			var temp : int;
			var randomIndex : int;
			for ( ;i < numElements; i++ ) {
				randomIndex = int( Math.random() * numElements );
				temp = array[ randomIndex ];
				array[ randomIndex ] = array[ i ];
				array[ i ] = temp;
			}
			return array;
		}
	}
}
