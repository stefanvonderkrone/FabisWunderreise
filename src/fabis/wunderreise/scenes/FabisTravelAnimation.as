package fabis.wunderreise.scenes {
	import com.junkbyte.console.Cc;
	import com.flashmastery.as3.game.interfaces.sound.ISoundItem;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisTravelAnimation extends BaseScene {

		protected static const ZOOM_DURATION_RATIO : Number = 0.1;
		protected static const TRAVEL_DURATION_RATIO : Number = 0.9;
		protected static const TARGET_SOUNDS : Vector.<String> = Vector.<String>( [
			"menuJourneyChichenItza",
			"menuJourneyChineseWall",
			"menuJourneyColosseum",
			"menuJourneyCristo",
			"menuJourneyMachuPicchu",
			"menuJourneyPetra",
			"menuJourneyTajMahal"
		] );
		protected static const TARGET_SCENES : Vector.<Class> = Vector.<Class>( [
			FabisChichenItzaQuiz,
			FabisChineseWallQuiz,
			FabisKolosseumWordsCapture,
			FabisCristoEstimate,
			FabisMachuPicchuMemory,
			FabisPetraWordsCapture,
			FabisTajMahalMemory ] );
		protected static const TARGET_COLORS : Vector.<uint> = Vector.<uint>( [
			0xE91C1C,
			0xFA2BEE,
			0x774183,
			0xFFF000,
			0x3D22E3,
			0x3FB627,
			0xFF5700
		] );
		protected static const TARGET_MC_ANIMATION : Number = 90;
		
		protected var _targets : Vector.<MovieClip>;
		protected var _targetSound : ISoundItem;
		protected var _lineContainer : Sprite;
		protected var _vehicle : FabisTravelVehicle;
		protected var _startPosition : Point;
		protected var _targetPosition : Point;
		protected var _currentPosition : Point;
		protected var _start : int;
		protected var _target : int;
		protected var _angle : Number;
		protected var _lineCounter : int = 0;
		protected var _fromBottomToTop : Boolean = false;
		protected var _straightFromTop : Boolean = false;
		

		public function FabisTravelAnimation( start : int, target : int ) {
			_start = start;
			_target = target;
			super();
		}
		
		private function get view() : FabisTravelAnimationView {
			return FabisTravelAnimationView( _view );
		}
		
		override protected function initView( evt : Event ) : void {
			super.initView( evt );
		}

		override protected function handleCreation() : void {
			_view = new FabisTravelAnimationView();
			_lineContainer = Sprite( view._worldMap.addChild( new Sprite() ) );
			_vehicle = FabisTravelVehicle( view._worldMap.addChild( new FabisTravelVehicle() ) );
			view._worldMap._chichenItza.gotoAndStop( 1 );
			view._worldMap._chineseWall.gotoAndStop( 1 );
			view._worldMap._colosseum.gotoAndStop( 1 );
			view._worldMap._cristo.gotoAndStop( 1 );
			view._worldMap._machuPicchu.gotoAndStop( 1 );
			view._worldMap._petra.gotoAndStop( 1 );
			view._worldMap._tajMahal.gotoAndStop( 1 );
			view._worldMap._homePic.gotoAndStop( 1 );
			_targets = Vector.<MovieClip>( [
				view._worldMap._chichenItza,
				view._worldMap._chineseWall,
				view._worldMap._colosseum,
				view._worldMap._cristo,
				view._worldMap._machuPicchu,
				view._worldMap._petra,
				view._worldMap._tajMahal,
				view._worldMap._home
			] );
			_targets[ _start ].gotoAndStop( _targets[ _start ].totalFrames );
			_startPosition = new Point( _targets[ _start ].x, _targets[ _start ].y );
			_targetPosition = new Point( _targets[ _target ].x, _targets[ _target ].y );
			_currentPosition = _startPosition.clone();
			_angle = getAngle();
			Cc.logch.apply( undefined, [ _angle.toString() ] );
			if ( _angle < 0 ) {
				_vehicle.scaleX = -1/3;
				if( !_fromBottomToTop && _angle < -10 )
					_vehicle.rotation = _angle + 90;
			} 
			else {
				_vehicle.scaleX = 1/3;
				if( !_fromBottomToTop )
					_vehicle.rotation = _angle - 90;
			}
			_vehicle.scaleY = 1/3;
			_vehicle.gotoAndStop( _target + 1 );
			view._worldMap.cacheAsBitmap = true;
			view.removeChild( view._menuButtons );
			super.handleCreation();
		}

		protected function getAngle() : Number {
			const a : Number = _targetPosition.x - _startPosition.x;
			const b : Number = _targetPosition.y - _startPosition.y;
			if( b < 0 ){
				_fromBottomToTop = true;
			}
			if( Math.abs( a ) <= 20 ){
				_straightFromTop = true;
			}
			return Math.acos( a / Math.sqrt( a*a + b*b ) ) * 180 / Math.PI - 90;
		}

		override protected function handleStart() : void {
			super.handleStart();
			_targetSound = gameCore.soundCore.getSoundByName( TARGET_SOUNDS[ _target ] );
			_targetSound.maxNumChannels = 1;
			_targetSound.play();
			TweenLite.to(
				view._worldMap,
				ZOOM_DURATION_RATIO * _targetSound.length, {
					scaleX: 3,
					scaleY: 3,
					onUpdate: updateWorldMapPosition,
					onComplete: startTravelAnimation
				}
			);
			view.stage.quality = StageQuality.LOW;
		}

		override protected function handleStop() : void {
			super.handleStop();
		}

		override protected function handleDisposal() : void {
			super.handleDisposal();
		}
		
		override public function update( deltaTime : Number ) : void {
		}
		
		protected function updateWorldMapPosition() : void {
			const stageWidth : int = view.stage.stageWidth;
			const stageHeight : int = view.stage.stageHeight;
			view._worldMap.x = _currentPosition.x / stageWidth * ( stageWidth - view._worldMap.width );
			view._worldMap.y = _currentPosition.y / stageHeight * ( stageHeight - view._worldMap.height );
		}
		
		protected function startTravelAnimation() : void {
			view.stage.quality = StageQuality.BEST;
			TweenLite.to(
				_currentPosition,
				TRAVEL_DURATION_RATIO * _targetSound.length, {
					x: _targetPosition.x,
					y: _targetPosition.y,
					onUpdate: updateTravelling,
					onComplete: showNextScene
				}
			);
		}
		
		protected function updateTravelling() : void {
			updateWorldMapPosition();
			_lineCounter++;
			_lineContainer.graphics.clear();
			_lineContainer.graphics.lineStyle( 3, TARGET_COLORS[ _target ] );
			_lineContainer.graphics.moveTo( _startPosition.x, _startPosition.y );
			_lineContainer.graphics.lineTo( _currentPosition.x, _currentPosition.y );
			_vehicle.x = _currentPosition.x;
			_vehicle.y = _currentPosition.y;
		}
		
		protected function showNextScene() : void {
			log("FabisTravelAnimation.showNextScene()");
			const mc : MovieClip = _targets[ _target ];
			const tweenProps : Object = { frame: mc.totalFrames };
			if ( FabisTravelAnimation.TARGET_SCENES[ _target ] ) {
				tweenProps.onComplete = TweenLite.delayedCall;
				tweenProps.onCompleteParams = [
					0.5,
					gameCore.director.replaceScene,
					[ new TARGET_SCENES[ _target ](), true ]
				];
			}
			TweenLite.to(
				mc,
				mc.totalFrames / TARGET_MC_ANIMATION,
				tweenProps
			);
			view._worldMap.setChildIndex( mc, view._worldMap.numChildren - 2 );
		}
	}
}
