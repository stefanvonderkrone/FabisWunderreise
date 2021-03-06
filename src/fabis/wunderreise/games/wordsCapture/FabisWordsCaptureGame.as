package fabis.wunderreise.games.wordsCapture {

	import com.flashmastery.as3.game.interfaces.core.IGameCore;
	import com.flashmastery.as3.game.interfaces.delegates.ISoundItemDelegate;
	import com.flashmastery.as3.game.interfaces.sound.ISoundCore;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;

	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	
	/**
	 * @author Stefanie Drost
	 */
	public class FabisWordsCaptureGame extends Sprite implements ISoundItemDelegate {
		
		public var _gameFinished : Boolean = false;
		protected var _gameOptions : FabisWordsCaptureGameOptions;
		protected var _soundCore : ISoundCore;
		protected var _gameCore : IGameCore;
		protected var _currentImageIndex : int;
		protected var _currentTime : int;
		
		
		public function FabisWordsCaptureGame() {
			
		}
		
		public function initWithOptions( options : FabisWordsCaptureGameOptions ) : void {
			
		}
		
		public function skipIntro( event : MouseEvent ) : void {
			
		}
		
		public function start() : void {
			
		}
		
		public function stop() : void {
			_gameFinished = true;
			_gameOptions.lipSyncher.gameCore.director.currentScene.stop();
		}
		
		
		public function set soundCore( soundCore : ISoundCore) : void {
			_soundCore = soundCore;
		}
		
		public function get soundCore() : ISoundCore {
			return _soundCore;
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

		public function get gameCore() : IGameCore {
			return _gameCore;
		}

		public function set gameCore(gameCore : IGameCore) : void {
			_gameCore = gameCore;
		}
		
		public function hasCurrentSound() : Boolean {
			return false;
		}
	}
}
