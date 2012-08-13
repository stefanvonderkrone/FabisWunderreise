package fabis.wunderreise.scenes {
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
		
		public function FabisCristoEstimate() {
			super();
		}

		private function get view() : FabisCristoView {
			return FabisCristoView( _view );
		}
	
		override protected function handleCreation() : void {
			_view = new FabisCristoView();
			
			_fabiCristoSmallContainer = view._fabiCristoSmallContainer;
			_fabiCristoContainer = view._fabiCristoContainer;
			
			_fabiSmall = new FabiSmall();
			_fabiSmall.width = 16;
			_fabiSmall.height = 50.5;
			_fabiSmall._fabi._lips.gotoAndStop( 1 );
			_fabiSmall._fabi._eyes.gotoAndStop( 1 );
			_fabiSmall._fabi._nose.gotoAndStop( 1 );
			_fabiSmall._fabi._arm.gotoAndStop( 1 );
			
		//	_fabiSmall.init();
			_fabiCristoSmallContainer.addChild( _fabiSmall );
			
			const estimateOptions : FabisEstimateGameOptions = new FabisEstimateGameOptions();
			//TODO: set to 2
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
			
			_game = new FabisEstimateGame();
			_game.initWithOptions( estimateOptions );
			
			_skipButton = new FabisSkipButton();
			_skipButton.x = 20;
			_skipButton.y = 20;
			estimateOptions.skipButton = _skipButton;
			_skipButton.addEventListener( MouseEvent.CLICK, _game.skipIntro);
			view.addChild( _skipButton );
			
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_game.soundCore = gameCore.soundCore;
			_lipSyncher.gameCore = gameCore;
			gameCore.juggler.addAnimatable( _lipSyncher );
		}
		
		override protected function handleStop() : void {
			super.handleStop();
			_game.stop();
		}
		
		override protected function handleStart() : void {
			super.handleStart();
			_game.start();
		}
		
		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
	}
}
