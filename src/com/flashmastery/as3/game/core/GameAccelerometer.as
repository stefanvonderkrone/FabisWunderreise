package com.flashmastery.as3.game.core {

	import com.flashmastery.as3.game.interfaces.core.IAccelerometer;

	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class GameAccelerometer extends Object implements IAccelerometer {

		protected var _accelerometer : Accelerometer;
		protected var _enabled : Boolean;
		protected var _angleXInRadiants : Number;
		protected var _angleYInRadiants : Number;
		protected var _angleZInRadiants : Number;
		protected var _accelerationX : Number;
		protected var _accelerationY : Number;
		protected var _accelerationZ : Number;
		protected var _created : Boolean;

		public function GameAccelerometer() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				if ( Accelerometer.isSupported )
					_accelerometer = new Accelerometer();
				_accelerationX = 0;
				_accelerationY = 0;
				_accelerationZ = 0;
				_angleXInRadiants = 0;
				_angleYInRadiants = 0;
				_angleZInRadiants = 0;
				_created = true;
				handleCreation();
			}
		}

		final public function get angleXInRadiants() : Number {
			return _angleXInRadiants;
		}

		final public function get angleYInRadiants() : Number {
			return _angleYInRadiants;
		}

		final public function get angleZInRadiants() : Number {
			return _angleZInRadiants;
		}

		final public function get accelerationX() : Number {
			return _accelerationX;
		}

		final public function get accelerationY() : Number {
			return _accelerationY;
		}

		final public function get accelerationZ() : Number {
			return _accelerationZ;
		}

		final public function get enabled() : Boolean {
			return _enabled;
		}

		public function set enabled( enabled : Boolean ) : void {
			_enabled = enabled && Accelerometer.isSupported;
			if ( _enabled )
				_accelerometer.addEventListener( AccelerometerEvent.UPDATE, updateHandler );
			else _accelerometer.removeEventListener( AccelerometerEvent.UPDATE, updateHandler );
		}

		protected function updateHandler( evt : AccelerometerEvent ) : void {
			_accelerationX = evt.accelerationX;
			_accelerationY = evt.accelerationY;
			_accelerationZ = evt.accelerationZ;
			const hypXY : Number = Math.sqrt( _accelerationX * _accelerationX + _accelerationY * _accelerationY );
			const hypXZ : Number = Math.sqrt( _accelerationX * _accelerationX + _accelerationZ * _accelerationZ );
			const hypYZ : Number = Math.sqrt( _accelerationY * _accelerationY + _accelerationZ * _accelerationZ );
			_angleXInRadiants = Math.sin( hypYZ / _accelerationZ );
			_angleYInRadiants = Math.sin( hypXZ / _accelerationX );
			_angleZInRadiants = Math.sin( hypXY / _accelerationY );
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
				enabled = false;
				_accelerometer = null;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}
	}
}
