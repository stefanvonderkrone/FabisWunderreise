package fabis.wunderreise.games.memory {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
		
		public var _gameFinished : Boolean = false;
		protected var _gameOptions : FabisMemoryGameOptions;
		protected var _gameContainer : Sprite;
		protected var _memoryCards : Vector.<FabisMemoryGameCard>;
		protected var _selectedCards : Vector.<FabisMemoryGameCard>;
		protected var _locked : Boolean = false;
		protected var _numCardsCompleted : int = 0;
		
		protected var _frameCounter : int = 0;
		protected var _lastXCoordinate : int = 0;
		protected var _lastYCoordinate : int = 0;
		
		protected var _soundCore : ISoundCore;
		protected var _introSound : ISoundItem;
		protected var _introSoundStarted : Boolean = false;
		protected var _feedbackSound : ISoundItem;
		protected var _feedbackSoundStarted : Boolean = false;
		protected var _pointsSound : ISoundItem;
		protected var _pointsSoundStarted : Boolean = false;
		protected var _buttonClickedSound : ISoundItem;
		public var _mainView : Sprite;
		protected var _cardAlreadySelected : Boolean = false;
		protected var _currentCard : FabisMemoryGameCard;
		protected var _lastX : Number;
		protected var _lastY : Number;
		
		private const _xCardDiff : int = 60;
		private const _yCardDiff : int = 60;
		private var _currentCardXCoordinate : int = 50;
		private var _currentCardYCoordinate : int = 50;
		private var _cardCounter : int = 0;
		public var _helpSoundStarted : Boolean = false;
		
		private var _introTimer : Timer;

		public function FabisMemoryGame() {
		}
		
		public function skipIntro( event : MouseEvent ) : void {
			_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
			_mainView.removeChild( _gameOptions.skipButton );
			
			_introTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleShowMemory); 
			//_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleShowMemory );
			_introSound.stop();
			_introSoundStarted = false;
			_buttonClickedSound = soundCore.getSoundByName("buttonClicked");
			_buttonClickedSound.play();
			showMemory();
		}
		
		public function removeAllEventListener() : void {
			if(_introTimer) _introTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleShowMemory); 
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
			if( !_helpSoundStarted ){
				if ( _locked || !( evt.target is FabisMemoryGameCard ) ) return;
				const card : FabisMemoryGameCard = FabisMemoryGameCard( evt.target );
				_buttonClickedSound = soundCore.getSoundByName("buttonClicked");
				_buttonClickedSound.play();
				card.mouseEnabled = false;
				_selectedCards.push( card );
				card.showCover( 0.25 );
				if ( _selectedCards.length == 2 ) {
					_locked = true;
					TweenLite.delayedCall( 0.5, compareSelectedCards );
				}
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
			_gameOptions.memoryGame.playFeedback( card1.id + 1 );
			_currentCard = card1; 
			_gameContainer.removeChild( card2 );
			_gameOptions.lipSyncher.delegate = this;
			_gameOptions.lipSyncher.start();
			enlargeCard( _currentCard );
			TweenLite.delayedCall( 0.5, unlockAndCheckGameStatus );
		}
		
		protected function enlargeCard( card : FabisMemoryGameCard ) : void {
			_gameContainer.setChildIndex( card, _gameContainer.numChildren - 1 );
			_gameContainer.removeEventListener( MouseEvent.CLICK, clickHandler );
			_gameContainer.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			_gameContainer.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			
			TweenLite.to( card, 1, {x: 230, y: 142, width: 400, height: 400} );
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
		
		private function moveToSide( currentCard : FabisMemoryGameCard ) : void {
			_cardCounter++;
			
			_gameContainer.removeChild( currentCard );
			currentCard.x = 520;
			currentCard.y = 300;
			_mainView.addChild( currentCard );
			_currentCard = currentCard;
			
			if( _cardCounter == 4 ) {
				_currentCardYCoordinate = 50;
				_currentCardXCoordinate += _xCardDiff;
			}
			
			TweenLite.to( currentCard, 1, { x: _currentCardXCoordinate, y: _currentCardYCoordinate, width: 50, height: 50 } );
			currentCard.addClickHandler();
			currentCard.addEventListener( MouseEvent.CLICK, handleClickOnCard );
			
			_currentCardYCoordinate += _yCardDiff;
			
			if( _cardCounter == 6 ){
				TweenLite.delayedCall( 1, playEnding );
			}
		}
		
		protected function playEnding() : void {
			_pointsSound = _soundCore.getSoundByName( "endingsMemory" );
			_pointsSoundStarted = true;
			_pointsSound.delegate = this;
			_pointsSound.play();
			_gameOptions.lipSyncher.start();
		}
		
		protected function handleClickOnCard( evt : MouseEvent ) : void {
			if( !_feedbackSoundStarted ){
				
				_gameContainer.removeEventListener( MouseEvent.CLICK, clickHandler );
				_gameContainer.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
				_gameContainer.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
				
				_buttonClickedSound = soundCore.getSoundByName("buttonClicked");
				_buttonClickedSound.play();
				_currentCard = FabisMemoryGameCard( evt.currentTarget );
				_currentCard.removeEventListener( MouseEvent.CLICK, handleClickOnCard );
				//Cc.logch.apply( undefined, [ evt.target.constructor ] );
				_lastX = _currentCard.x;
				_lastY = _currentCard.y;
				TweenLite.to( _currentCard, 1, {x: 500, y: 300, width: 400, height: 400} );
				_gameOptions.lipSyncher.start();
				_gameOptions.memoryGame.playFeedback( _currentCard.id + 1 );
				_cardAlreadySelected = true;
			}
			
		}
		
		protected function moveBackToSide( card : FabisMemoryGameCard, x : Number, y : Number ) : void {
			TweenLite.to( _currentCard, 1, {x: x, y: y, width: 50, height: 50} );
			card.addEventListener( MouseEvent.CLICK, handleClickOnCard );
			_cardAlreadySelected = false;
		}
		
		public function start() : void {
			_gameOptions.lipSyncher.delegate = this;
			_gameOptions.lipSyncher.start();
			
			_introTimer = new Timer(1000, _gameOptions.showMemoryTime);
			_introTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleShowMemory); 
			_introTimer.start();
			
			//_gameOptions.fabi.addEventListener( Event.ENTER_FRAME, handleShowMemory );
		}
		
		/*public function handleShowMemory( event : Event ) : void {
			_frameCounter++;
			if( _frameCounter == (_gameOptions.showMemoryTime * 60) ){
				_gameOptions.fabi.removeEventListener( Event.ENTER_FRAME, handleShowMemory );
				showMemory();
				_frameCounter = 0;
			}
		}*/
		
		public function handleShowMemory(event:TimerEvent) : void { 
			Cc.logch.apply( undefined, [ "Zeige Karten" ] );
			_introTimer.stop();
			_introTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleShowMemory); 
			showMemory();
		}
		
		public function showMemory() : void {
			//_gameContainer.addEventListener( MouseEvent.CLICK, clickHandler );
			_gameContainer.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			_gameContainer.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			tweenIn();
		}
		
		public function stop() : void {
			_gameContainer.removeEventListener( MouseEvent.CLICK, clickHandler );
			_gameContainer.removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
			_gameContainer.removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
			_gameFinished = true;
			_gameOptions.lipSyncher.gameCore.director.currentScene.stop();
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
				_gameContainer.addEventListener( MouseEvent.CLICK, clickHandler );
				_introSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				if( _gameOptions.skipButton != null ) {
					_gameOptions.skipButton.removeEventListener( MouseEvent.CLICK, skipIntro);
					_mainView.removeChild( _gameOptions.skipButton );
				}
				
			}
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				
				if( _cardAlreadySelected ){
					moveBackToSide( _currentCard, _lastX, _lastY );
					_gameContainer.addEventListener( MouseEvent.CLICK, clickHandler );
					_gameContainer.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
					_gameContainer.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
				}
				else{
					moveToSide( _currentCard );
					_gameContainer.addEventListener( MouseEvent.CLICK, clickHandler );
					_gameContainer.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler );
					_gameContainer.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler );
				}
			}
			if( _pointsSoundStarted ){
				_pointsSoundStarted = false;
				_gameOptions.lipSyncher.stop();
				TweenLite.delayedCall( 1, stop );
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
		
		public function playFeedback( cardNumber : int ) : void {
			_feedbackSoundStarted = true;
			_feedbackSound.delegate = this;
			_feedbackSound.play();
		}

		public function get gameCore() : IGameCore {
			return null;
		}

		public function set gameCore(gameCore : IGameCore) : void {
		}
		
		public function hasCurrentSound() : Boolean {
			if( _introSoundStarted || _feedbackSoundStarted ){
				return true;
			}
			return false;
		}
	}
}
