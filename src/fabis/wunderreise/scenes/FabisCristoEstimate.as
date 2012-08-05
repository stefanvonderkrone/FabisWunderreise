package fabis.wunderreise.scenes {
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import fabis.wunderreise.games.estimate.FabiEstimateSmall;
	import flash.events.Event;
	import fabis.wunderreise.games.estimate.FabisEstimateGame;
	import fabis.wunderreise.games.estimate.FabisEstimateGameOptions;
	/**
	 * @author Stefanie Drost
	 */
	public class FabisCristoEstimate extends BaseScene {
		
		protected var _game : FabisEstimateGame;
		protected var _fabiSmall : FabiEstimateSmall;
		
		protected var _fabiCristoSmallContainer : FabiCristoSmallContainer;
		protected var _fabiCristoContainer : FabiCristoContainer;
		
		protected var _introSound : ISoundItem;
		
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
			
			_fabiSmall = new FabiEstimateSmall();
			_fabiSmall.init();
			_fabiCristoSmallContainer.addChild( _fabiSmall.view );
			
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
			
			_game = new FabisEstimateGame();
			_game.initWithOptions( estimateOptions );
			
			super.handleCreation();
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
			_game.soundCore = gameCore.soundCore;
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
