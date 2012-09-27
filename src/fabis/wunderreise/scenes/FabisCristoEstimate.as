package fabis.wunderreise.scenes {
	import com.greensock.TweenLite;
	import fabis.wunderreise.sound.FabisEyeTwinkler;
	import fabis.wunderreise.sound.FabisLipSyncher;
	import flash.events.MouseEvent;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import flash.events.Event;
	import fabis.wunderreise.games.estimate.FabisEstimateGame;
	import fabis.wunderreise.games.estimate.FabisEstimateGameOptions;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisCristoEstimate extends BaseScene {
		
		protected var _game : FabisEstimateGame;
		protected var _fabiSmall : FabiSmall;
		protected var _skipButton : FabisSkipButton;
		
		protected var _fabiCristoSmallContainer : FabiCristoSmallContainer;
		protected var _fabiCristoContainer : FabiCristoContainer;
		
		protected var _introSound : ISoundItem;
		protected var _lipSyncher : FabisLipSyncher;
		protected var _eyeTwinkler : FabisEyeTwinkler;
		protected var _menuButtons : FabisMenuButtons;
		protected var _storage : *;
		
		public function FabisCristoEstimate() {
			super();
		}

		private function get view() : FabisCristoView {
			return FabisCristoView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisCristoView();
			_menuButtons = new FabisMenuButtons();
			_fabiCristoSmallContainer = view._fabiCristoSmallContainer;
			_fabiCristoContainer = view._fabiCristoContainer;
			
			_fabiSmall = new FabiSmall();
			_fabiSmall.width = 16;
			_fabiSmall.height = 50.5;
			_fabiSmall._fabi._lips.gotoAndStop( 1 );
			_fabiSmall._fabi._eyes.gotoAndStop( 1 );
			_fabiSmall._fabi._nose.gotoAndStop( 1 );
			_fabiSmall._fabi._arm.gotoAndStop( 1 );
			
			_fabiCristoSmallContainer.addChild( _fabiSmall );
			
			const estimateOptions : FabisEstimateGameOptions = new FabisEstimateGameOptions();
			estimateOptions.exerciseNumber = 2;
			estimateOptions.flipTime = 12;
			
			estimateOptions.showGiraffesTime = 6;
			estimateOptions.removeStatueTime = 21;
			estimateOptions.showSockelTime = 27;
			estimateOptions.showDoneButtonTime = 32;
			
			estimateOptions.showRoadSign = 9;
			estimateOptions.showCarsTime = 10;
			estimateOptions.removeCarsStatueTime = 16;
			
			estimateOptions.fabiCristoSmallContainer = _fabiCristoSmallContainer;
			estimateOptions.fabiCristoContainer = _fabiCristoContainer;
			estimateOptions.fabiSmall = _fabiSmall;
			
			_lipSyncher = new FabisLipSyncher();
			estimateOptions.lipSyncher = _lipSyncher;
			
			_eyeTwinkler = new FabisEyeTwinkler();
			_eyeTwinkler.initWithEyes( _fabiSmall._fabi._eyes );
			estimateOptions.eyeTwinkler = _eyeTwinkler;
			
			_game = new FabisEstimateGame();
			_game.initWithOptions( estimateOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			estimateOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view.addChild( _skipButton );
			
			view.addChild( _menuButtons );
			initMainMenu( _menuButtons );
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_game.soundCore = gameCore.soundCore;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
			_eyeTwinkler.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _eyeTwinkler );
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			_eyeTwinkler.stop();
			_lipSyncher.stop();
			_game.soundCore.stopAllSounds();
			
			if( _game._gameFinished ){
				_storage = gameCore.localStorage.getStorageObject();
				
				if( _storage.stampArray["cristoStamp"] ){
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
				else{
					_storage.stampArray["cristoStamp"] = false;
					_storage.finishedCristoRedentor = true;
					gameCore.localStorage.saveStorage();
					
					TweenLite.delayedCall(
						2,
						gameCore.director.replaceScene,
						[ new FabisPassport(), true ]
					);
				}
			}
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			_eyeTwinkler.start();
			_game.start();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
	}
}
