package fabis.wunderreise.scenes {
	import flash.display.MovieClip;
	import fabis.wunderreise.passport.FabisPassportOptions;
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
		
		public var _options : FabisPassportOptions;
		protected var _feedbackSound : ISoundItem;
		protected var _feedbackSoundStarted : Boolean = false;
		
		public function FabisPassport() {
			super();
		}
		
		private function get view() : FabisPassportView {
			return FabisPassportView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisPassportView();
			
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			initPassport();
		}
		
		override protected function handleStop() : void {
			super.handleStop();
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
			var _stamp : MovieClip;
			var _stampName : String;
			
			for( var i : int = 0; i < _options.stampArray.length; i++ ){
				
				_stampName = "_" + _options.stampArray[ i ].name;
				_stamp = MovieClip( view._passportContainer.getChildByName( _stampName ) );
				
				if( _options.stampArray[ i ].checked ){
					_stamp.gotoAndStop( 2 );
				}
				else{
					_stamp.gotoAndStop( 1 );
				}
			}
		}
		
		public function getNewStamp( wonderOfTheWorld : String ) : void {
			
			switch( wonderOfTheWorld ){
				case "machuPicchu":
					break;
				case "cristo":
				
					break;
				case "chichenItza":
				
					break;
				case "colosseum":
				
					break;
				case "petra":
				
					break;
				case "chineseWall":
				
					break;
				case "tajMahal":
				
					break;
			}
		}
		
		protected function playStampFeedback( stampNumber : int ) : void {
			/*switch( stampNumber ) {
				case 1:
					_feedbackSound = _soundCore.getSoundByName( "menuPassportStamp1" );
					break;
				case 2:
					_feedbackSound = _soundCore.getSoundByName( "menuPassportStamp2" );
					break;
				case 3:
					_feedbackSound = _soundCore.getSoundByName( "menuPassportStamp3" );
					break;
				case 4:
					_feedbackSound = _soundCore.getSoundByName( "menuPassportStamp4" );
					break;
				case 5:
					_feedbackSound = _soundCore.getSoundByName( "menuPassportStamp5" );
					break;
				case 6:
					_feedbackSound = _soundCore.getSoundByName( "menuPassportStamp6" );
					break;
			}*/
			
			/*_feedbackSoundStarted = true;
			_feedbackSound.delegate = this;
			_feedbackSound.play();*/
			
		}
		
		public function reactOnSoundItemProgressEvent(evt : ProgressEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemEvent(evt : Event, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSoundComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemLoadComplete(soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemErrorEvent(evt : ErrorEvent, soundItem : ISoundItem) : void {
		}

		public function reactOnSoundItemSampleDataEvent(evt : SampleDataEvent, soundItem : ISoundItem) : void {
		}
	}
}
