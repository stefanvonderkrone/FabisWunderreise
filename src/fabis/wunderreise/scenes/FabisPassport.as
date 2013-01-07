package fabis.wunderreise.scenes {
	import flash.display.MovieClip;
	import com.flashmastery.as3.game.interfaces.core.IInteractiveGameObject;
	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import fabis.wunderreise.sound.IFabisLipSyncherDelegate;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import com.junkbyte.console.Cc;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import fl.text.TLFTextField;
	import flash.filters.GlowFilter;
	import flash.events.ProgressEvent;

	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.events.ErrorEvent;
	import flash.events.SampleDataEvent;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.greensock.TweenLite;
	import flash.events.Event;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisPassport extends BaseScene implements IFabisLipSyncherDelegate {
		
		
		protected var _feedbackSound : ISoundItem;
		protected var _feedbackSoundStarted : Boolean = false;
		protected var _endSound : ISoundItem;
		protected var _endSoundStarted : Boolean = false;
		protected var _storage : *;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _menuButtons : FabisMenuButtons;
		protected var _soundCore : ISoundCore;
		protected var _newStamp : Boolean = false;
		protected var _fabi : FabiIntroComplete;
		protected var _callFromGame : Boolean = false;
		protected var _gameFinished : Boolean = false;
		
		
		public function FabisPassport() {
			super();
			// TODO what happens, when all trophies where achieved?
		}
		
		private function get view() : FabisPassportView {
			return FabisPassportView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisPassportView();
			_menuButtons = new FabisMenuButtons();
			
			_fabi = new FabiIntroComplete();
			_fabi._lips.gotoAndStop( 1 );
			_fabi._eyes.gotoAndStop( 1 );
			_lipSyncher = new FabisLipSyncher();
			_lipSyncher.delegate = this;
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( _fabi._eyes );
			_fabi.height = 386;
			_fabi.width = 202;
			
			view._passportContainer._chichenItzaStamp.gotoAndStop( 1 );
			view._passportContainer._chineseWallStamp.gotoAndStop( 1 );
			view._passportContainer._colosseumStamp.gotoAndStop( 1 );
			view._passportContainer._cristoStamp.gotoAndStop( 1 );
			view._passportContainer._machuPicchuStamp.gotoAndStop( 1 );
			view._passportContainer._petraStamp.gotoAndStop( 1 );
			view._passportContainer._tajMahalStamp.gotoAndStop( 1 );
			view._passportContainer._rank0.visible = true;
			view._passportContainer._rank1.visible = false;
			view._passportContainer._rank2.visible = false;
			view._passportContainer._rank3.visible = false;
			view._passportContainer._rank4.visible = false;
			view._passportContainer._rank5.visible = false;
			view._passportContainer._rank6.visible = false;
			view._passportContainer._rank7.visible = false;
			
			view.addChild( _menuButtons );
			initMainMenu( _menuButtons );
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
			_eyeTwinkler.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _eyeTwinkler );
			
			_soundCore = gameCore.soundCore;
			_storage = gameCore.localStorage.getStorageObject();
			if( _storage.currentGameScene != null ){
				_callFromGame = true;
			}
			initPassport();
			_menuButtons.removeChild( _menuButtons._btnHelp );
			_menuButtons.removeChild( _menuButtons._btnPassport );
		}
		
		override protected function handleStop() : void {
			if( _storage.currentGameScene != null && !( _storage.currentGameScene is FabisMainMenu ) ){
				_storage.currentGameScene = null;
				gameCore.localStorage.saveStorage();
				TweenLite.delayedCall(
					2,
					gameCore.director.popScene
				);
			}
			else{
				super.handleStop();
				TweenLite.delayedCall(
					1,
					gameCore.director.replaceScene,
					[ new FabisMainMenu(), true ]
				);
			}
			
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			var _openSound : ISoundItem =_soundCore.getSoundByName("passportOpen");
			_openSound.play();
			TweenLite.fromTo(view._passportContainer, 1, 
				{ x: 450, y: 300,width: 0, height: 0}, { x: 78, y: 13,width: 740, height: 565} );
				
			if( !( _storage.currentGameScene is FabisMainMenu ) && ( _callFromGame || ( !_newStamp && _gameFinished ) ) ){
				_menuButtons.removeChild( _menuButtons._btnMap );
				TweenLite.delayedCall( 3, stop );
			}			
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
		
		private function initPassport() : void {
			checkForNewStamp( "machuPicchuStamp", _storage.finishedMachuPicchu );
			checkForNewStamp( "chichenItzaStamp", _storage.finishedChichenItza );
			checkForNewStamp( "chineseWallStamp", _storage.finishedChineseWall );
			checkForNewStamp( "colosseumStamp", _storage.finishedColosseum );
			checkForNewStamp( "cristoStamp", _storage.finishedCristoRedentor );
			checkForNewStamp( "petraStamp", _storage.finishedPetra );
			checkForNewStamp( "tajMahalStamp", _storage.finishedTajMahal );
			
			
			if( _storage.finishedMachuPicchu ) view._passportContainer._machuPicchuStamp.gotoAndStop( 2 );
			if( _storage.finishedChichenItza ) view._passportContainer._chichenItzaStamp.gotoAndStop( 2 );
			if( _storage.finishedChineseWall ) view._passportContainer._chineseWallStamp.gotoAndStop( 2 );
			if( _storage.finishedColosseum ) view._passportContainer._colosseumStamp.gotoAndStop( 2 );
			if( _storage.finishedCristoRedentor ) view._passportContainer._cristoStamp.gotoAndStop( 2 );
			if( _storage.finishedPetra ) view._passportContainer._petraStamp.gotoAndStop( 2 );
			if( _storage.finishedTajMahal ) view._passportContainer._tajMahalStamp.gotoAndStop( 2 );
			
			checkRanks( _storage._stampCounter );
		}
		
		
		private function checkForNewStamp( stamp : String, gameFinished : Boolean ) : void {
			if( !_storage.stampArray[ stamp ] && gameFinished ){
				_storage._stampCounter++;
				_storage.stampArray[ stamp ] = true;
				gameCore.localStorage.saveStorage();
				_newStamp = true;
				view.removeChild( _menuButtons );
				playStampFeedback( _storage._stampCounter/*,  stamp */);
			}
			else if( gameFinished ){
				_gameFinished = true;
			}
		}
		
		private function checkRanks( rankNumber : int ) : void {
			var i : int;
			for( i = 0; i <= rankNumber; i++ ){
				view._passportContainer.getChildByName("_rank" + i.toString() ).visible = true;
			}
		}
		
		private function playEnd() : void {
			_lipSyncher.start();
			_eyeTwinkler.start();
			_endSound  =_soundCore.getSoundByName("menuOutro");
			_endSoundStarted = true;
			_endSound.delegate = this;
			_endSound.play();
		}
		
		protected function playStampFeedback( stampNumber : int/*, stamp : String*/ ) : void {
			switch( stampNumber ) {
				case 1:
					_feedbackSound = gameCore.soundCore.getSoundByName( "menuPassportStamp1" );
					break;
				case 2:
					_feedbackSound = gameCore.soundCore.getSoundByName( "menuPassportStamp2" );
					break;
				case 3:
					_feedbackSound = gameCore.soundCore.getSoundByName( "menuPassportStamp3" );
					break;
				case 4:
					_feedbackSound = gameCore.soundCore.getSoundByName( "menuPassportStamp4" );
					break;
				case 5:
					_feedbackSound = gameCore.soundCore.getSoundByName( "menuPassportStamp5" );
					break;
				case 6:
					_feedbackSound = gameCore.soundCore.getSoundByName( "menuPassportStamp6" );
					break;
				case 7:
					view.addChild( _fabi );
					TweenLite.fromTo( _fabi, 1, { x : -_fabi.width, y : 620 - _fabi.height}, { x : 10, onComplete : playEnd });
					break;
			}
			
			if( stampNumber < 7 ){
				_feedbackSoundStarted = true;
				_feedbackSound.delegate = this;
				_feedbackSound.play();
			}
		}

		override public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				stop();
			}
		}

		public function reactOnCumulatedSpectrum(cumulatedSpectrum : Number) : void {
			const lips : MovieClip = _fabi._lips;
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
	}
}
