package fabis.wunderreise.passport {
	/**
	 * @author Stefanie Drost
	 */
	public class FabisPassportOptions{
		
		public var stampCounter : int = 0;
		public var stampArray : Array = [ {name : "chichenItzaStamp" , checked :  false },
										{name : "machuPicchuStamp" , checked :  false },
										{name : "cristoStamp" , checked : false },
										{name : "colosseumStamp" , checked : false },
										{name : "petraStamp" , checked : false },
										{name : "chineseWallStamp" , checked : false },
										{name : "tajMahalStamp" , checked : false } 
									];
		
		
		public function FabisPassportOptions(){
			
		}
		
		public function reset() : void {
			stampArray = [ {name : "chichenItzaStamp" , checked :  false },
							{name : "machuPicchuStamp" , checked :  false },
							{name : "cristoStamp" , checked : false },
							{name : "colosseumStamp" , checked : false },
							{name : "petraStamp" , checked : false },
							{name : "chineseWallStamp" , checked : false },
							{name : "tajMahalStamp" , checked : false } 
						];
		}
		
		public function getRank() : String {
			var _rank : String;
			
			switch( stampCounter ){
				case 0:
					_rank = "Stubenhocker";
					break;
				case 0:
					_rank = "Stromer";
					break;
				case 0:
					_rank = "Ausfluegler";
					break;
				case 0:
					_rank = "Landstreicher";
					break;
				case 0:
					_rank = "Reisender";
					break;
				case 0:
					_rank = "Nomade";
					break;
				case 0:
					_rank = "Abenteurer";
					break;
			}
			
			return _rank;
		}
	}
}
