package fabis.wunderreise.games.memory {

	import flash.geom.Rectangle;
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisMemoryGame extends Sprite {
		
		protected var _gameOptions : FabisMemoryGameOptions;
		protected var _gameContainer : Sprite;
		protected var _memoryCards : Vector.<FabisMemoryGameCard>;
		protected var _selectedCards : Vector.<FabisMemoryGameCard>;
		protected var _locked : Boolean = false;
		protected var _numCardsCompleted : int = 0;

		public function FabisMemoryGame() {
		}
		
		public function initWithOptions( options : FabisMemoryGameOptions ) : void {
			_gameOptions = options;
			_gameContainer = Sprite( addChild( new Sprite() ) );
			_selectedCards = new Vector.<FabisMemoryGameCard>();
			var numCards : int = _gameOptions.numCards;
			const numColumns : int = _gameOptions.numColumns;
			var card : FabisMemoryGameCard;
			var xPos : int;
			var yPos : int;
			_memoryCards = new Vector.<FabisMemoryGameCard>( numCards, true );
			const cardsDistribution : Vector.<uint> = createRandomCardDistribution( numCards / 2, 2 );
			const coverAsset : Class = _gameOptions.coverAsset;
			const cardAssets : Vector.<Class> = _gameOptions.cardAssets;
			while ( --numCards >= 0 ) {
				card = new FabisMemoryGameCard();
				card.setSize( _gameOptions.cardWidth, _gameOptions.cardHeight );
				card.cover = new coverAsset();
				card.card = new ( Class( cardAssets[ cardsDistribution[ numCards ] ] ) )();
				card.id = cardsDistribution[ numCards ];
				xPos = ( numCards % numColumns );
				yPos = int( numCards / numColumns );
				card.x = card.width * xPos + _gameOptions.gapBetweenCards * xPos;
				card.y = card.height * yPos + _gameOptions.gapBetweenCards * yPos;
				card.mouseChildren = false;
				card.useHandCursor = true;
				card.buttonMode = true;
				_memoryCards[ numCards ] = card;
				_gameContainer.addChild( card );
			}
			const bounds : Rectangle = _gameContainer.getBounds( _gameContainer );
			_gameContainer.x = -bounds.x;
			_gameContainer.y = -bounds.y;
		}

		protected function createRandomCardDistribution( numCards : int, numOfAppearence : int ) : Vector.<uint> {
			const numElements : uint = numCards * numOfAppearence;
			var distribution : Vector.<uint> = new Vector.<uint>( numElements, true );
			var index : int = numElements;
			while ( --index >= 0 ) {
				distribution[ index ] = ( index % numCards );
			}
			var cardID : uint;
			var randomIndex : uint;
			index = numElements;
			while ( --index >= 0 ) {
				randomIndex = int( Math.random() * numElements );
				cardID = distribution[ randomIndex ];
				distribution[ randomIndex ] = distribution[ index ];
				distribution[ index ] = cardID;
			}
			return distribution;
		}

		protected function clickHandler( evt : MouseEvent ) : void {
//			trace( "VBDGameScreen.clickHandler(evt)", evt.currentTarget, evt.target );
			if ( _locked || !( evt.target is FabisMemoryGameCard ) ) return;
			const card : FabisMemoryGameCard = FabisMemoryGameCard( evt.target );
			card.mouseEnabled = false;
			_selectedCards.push( card );
			card.showCover( 0.25 );
			if ( _selectedCards.length == 2 ) {
				_locked = true;
				TweenLite.delayedCall( 0.5, compareSelectedCards );
			}
		}

		protected function mouseOverHandler( evt : MouseEvent ) : void {
			if ( evt.target is FabisMemoryGameCard )
				FabisMemoryGameCard( evt.target ).highlight( 0.25 );
		}

		protected function mouseOutHandler( evt : MouseEvent ) : void {
			if ( evt.target is FabisMemoryGameCard )
				FabisMemoryGameCard( evt.target ).dehighlight( 0.25 );
		}

		protected function compareSelectedCards() : void {
			if ( _selectedCards.length < 2 ) {
				TweenLite.delayedCall(1, resetSelectedCards);
			} else {
				const card0 : FabisMemoryGameCard = _selectedCards[ 0 ];
				const card1 : FabisMemoryGameCard = _selectedCards[ 1 ];
				if ( card0.id == card1.id ) {
					_numCardsCompleted += 2;
					removeSelectedCards();
				}
				else TweenLite.delayedCall(1, resetSelectedCards);
			}
		}

		protected function removeSelectedCards() : void {
			// TODO remove game cards
			// TODO show card infos
			TweenLite.delayedCall( 0.5, unlockAndCheckGameStatus );
		}
		
		protected function resetSelectedCards() : void {
			var index : int = _selectedCards.length;
			var card : FabisMemoryGameCard;
			while ( --index >= 0 ) {
				card = _selectedCards[ index ];
				card.mouseEnabled = true;
				card.hideCover( 0.25 );
			}
			TweenLite.delayedCall( 0.25, unlockAndCheckGameStatus );
		}

		private function unlockAndCheckGameStatus() : void {
			_locked = false;
			_selectedCards.length = 0;
			if ( _numCardsCompleted == _memoryCards.length ) {
				// TODO memory game finished
				//tweenOut();
			}
		}
		
		public function start() : void {
			_gameContainer.addEventListener( MouseEvent.CLICK, clickHandler );
			_gameContainer.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			_gameContainer.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			tweenIn();
		}
		
		public function stop() : void {
			_gameContainer.removeEventListener( MouseEvent.CLICK, clickHandler );
			_gameContainer.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			_gameContainer.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
		}

		public function tweenIn() : void {
			var index : int = _memoryCards.length;
			var card : FabisMemoryGameCard;
			while ( --index >= 0 ) {
				card = _memoryCards[ index ];
				TweenLite.from( card, 0.25, { delay: index / 20, alpha: 0 } );
			}
		}

		public function tweenOut() : void {
			var index : int = _memoryCards.length;
			var card : FabisMemoryGameCard;
			while ( --index >= 0 ) {
				card = _memoryCards[ index ];
				TweenLite.to( card, 0.5, { delay: index / 20, alpha: 1 } );
			}
		}
	}
}
