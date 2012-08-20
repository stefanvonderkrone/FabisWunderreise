package fabis.wunderreise.games.memory {
	import com.junkbyte.console.Cc;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;

	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.SampleDataEvent;

	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import fabis.wunderreise.sound.IFabisLipSyncherDelegate;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisMemoryGame extends Sprite implements ISoundItemDelegate, IFabisLipSyncherDelegate {
		
		protected var _gameOptions : FabisMemoryGameOptions;
		protected var _gameContainer : Sprite;
		protected var _memoryCards : Vector.<FabisMemoryGameCard>;
		protected var _selectedCards : Vector.<FabisMemoryGameCard>;
		protected var _locked : Boolean = false;
		protected var _numCardsCompleted : int = 0;
		
		protected var _frameCounter : int = 0;
		
		protected var _soundCore : ISoundCore;
		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		protected var _feedbackSound : ISoundItem;
		protected var _feedbackSoundStarted : Boolean = false;
		public var _mainView : Sprite;
		
		protected var _currentCards : Array = new Array();
		
		private const _xCardDiff : int = 60;
		private const _yCardDiff : int = 60;
		private var _currentCardXCoordinate : int = 50;
		private var _currentCardYCoordinate : int = 50;
		private var _cardCounter : int = 0;

		public function FabisMemoryGame() {
		}
		
		public function skipIntro( event : MouseEvent ) : void {
			_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
			_mainView.removeChild( _gameOptions.skipButton );
			_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleShowMemory );
			_introSound.stop();
			_introSoundStarted = false;
			showMemory();
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
				
				card.visible = false;
				
				_memoryCards[ numCards ] = card;
				_gameContainer.addChild( card );
			}
			const bounds : Rectangle = _gameContainer.getBounds( _gameContainer );
			_gameContainer.x = -bounds.x + 50;
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
				var card0 : FabisMemoryGameCard = _selectedCards[ 0 ];
				var card1 : FabisMemoryGameCard = _selectedCards[ 1 ];
				if ( card0.id == card1.id ) {
					_numCardsCompleted += 2;
					removeSelectedCards( card0, card1 );
				}
				else TweenLite.delayedCall(1, resetSelectedCards);
			}
		}

		protected function removeSelectedCards( card1 : FabisMemoryGameCard,  card2 : FabisMemoryGameCard) : void {
			// TODO remove game cards
			// TODO show card infos
			_gameOptions.memoryGame.playFeedback( card1.id + 1 );
			_currentCards[0] = card1; 
			_currentCards[1] = card2; 
			_gameOptions.lipSyncher.delegate = this;
			_gameOptions.lipSyncher.start();
			
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
		
		private function moveToSide( currentCards : Array ) : void {
			var card0 : FabisMemoryGameCard = currentCards[ 0 ];
			var card1 : FabisMemoryGameCard = currentCards[ 1 ];
			card0.visible = false;
			card1.visible = false;
			
			_cardCounter++;
			
			_gameContainer.removeChild( card0 );
			_mainView.addChild( card0 );
			
			card0.width = 50;
			card0.height = 50;
			
			if( _cardCounter == 4 ) {
				_currentCardYCoordinate = 50;
				_currentCardXCoordinate += _xCardDiff;
			}
			
			card0.y = _currentCardYCoordinate;
			card0.x = _currentCardXCoordinate;
			_currentCardYCoordinate += _yCardDiff;
			card0.visible = true;
		}
		
		public function start() : void {
			_gameOptions.lipSyncher.delegate = this;
			_gameOptions.lipSyncher.start();
			_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleShowMemory );
		}
		
		public function handleShowMemory( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == (_gameOptions.showMemoryTime * 60) ){
				_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleShowMemory );
				showMemory();
				_frameCounter = 0;
			}
		}
		
		public function showMemory() : void {
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
				card.visible = true;
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
		
		public function set soundCore( soundCore : ISoundCore) : void {
			_soundCore = soundCore;
		}
		
		public function get soundCore() : ISoundCore {
			return _soundCore;
		}
		
		public function playIntro() : void {
			_introSoundStarted = true;
			_introSound.delegate = this;
			_introSound.play();
		}

		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _introSoundStarted ){
				_introSoundStarted = false;
				_gameOptions.lipSyncher.stop();
			}
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				moveToSide( _currentCards );
			}
		}

		public function reactOnSoundItemLoadComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemErrorEvent(evt : ErrorEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSampleDataEvent(evt : SampleDataEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnCumulatedSpectrum(cumulatedSpectrum : Number) : void {
			var lips : MovieClip = _gameOptions.fabi._lips;
			
			if ( cumulatedSpectrum > 30 ) {
				lips.gotoAndStop(
					int( Math.random() * ( lips.totalFrames - 1 ) + 2 )
				);
			} else lips.gotoAndStop( 1 );
		}

		public function reactOnStart(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnStop(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnDisposal(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnAddedToDelegater(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnRemovalFromDelegater(delegater : IInteractiveGameObject) : void {
		}

		public function reactOnGameFinished(result : Object, gameCore : IGameCore) : void {
		}

		public function get gameCore() : IGameCore {
			return null;
		}

		public function set gameCore(gameCore : IGameCore) : void {
		}
		
		public function playFeedback( cardNumber : int ) : void {
			_feedbackSoundStarted = true;
			_feedbackSound.delegate = this;
			_feedbackSound.play();
		}
	}
}
