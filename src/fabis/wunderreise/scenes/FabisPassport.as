package fabis.wunderreise.scenes {
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
	public class FabisPassport extends BaseScene implements ISoundItemDelegate {
		
		
		protected var _feedbackSound : ISoundItem;
		protected var _feedbackSoundStarted : Boolean = false;
		protected var _storage : *;
		protected var myGlow : GlowFilter = new GlowFilter();
		protected var _menuButtons : FabisMenuButtons;
		
		public function FabisPassport() {
			super();
		}
		
		private function get view() : FabisPassportView {
			return FabisPassportView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisPassportView();
			_menuButtons = new FabisMenuButtons();
			
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
			_storage = gameCore.localStorage.getStorageObject();
			initPassport();
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			
			TweenLite.delayedCall(
				1,
				gameCore.director.replaceScene,
				[ new FabisMainMenu(), true ]
			);
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			TweenLite.fromTo(view._passportContainer, 1, 
				{ x: 450, y: 300,width: 0, height: 0}, { x: 78, y: 13,width: 740, height: 565} );
			
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
		
		private function initPassport() : void {
			//Cc.logch.apply( undefined, [_storage.finishedMachuPicchu] );
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
				playStampFeedback( _storage._stampCounter,  stamp );
			}
		}
		
		private function checkRanks( rankNumber : int ) : void {
			var i : int;
			for( i = 0; i <= rankNumber; i++ ){
				view._passportContainer.getChildByName("_rank" + i.toString() ).visible = true;
			}
		}
		
		protected function playStampFeedback( stampNumber : int, stamp : String ) : void {
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
			}
			
			_feedbackSoundStarted = true;
			_feedbackSound.delegate = this;
			_feedbackSound.play();
			//highlightStamp( stamp );
		}
		
		/*private function highlightStamp( stamp : String ) : void {
			var _stampName : String = "_" + stamp;
			var _newStamp : MovieClip;
			_newStamp = MovieClip( view._passportContainer.getChildByName( _stampName ) );
			
			myGlow.color = 0x33CC33;
			
			myGlow.blurX = 10;
			myGlow.blurY = 10;
			_newStamp.filters = [myGlow];
			
		}*/
		
		/*private function removeHighlight( stamp : String ) : void{
			myGlow.blurX = 10;
			myGlow.blurY = 10;
			stamp.filters = [myGlow];
		}*/
		
		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
			if( _feedbackSoundStarted ){
				_feedbackSoundStarted = false;
				//removeHighlight
				stop();
			}
		}

		public function reactOnSoundItemLoadComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemErrorEvent(evt : ErrorEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSampleDataEvent(evt : SampleDataEvent, soundItem : ISoundItem) : void {
		}
	}
}
