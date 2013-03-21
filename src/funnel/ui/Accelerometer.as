﻿package funnel.ui {	import flash.events.IEventDispatcher;	import flash.events.EventDispatcher;	import flash.events.Event;	import funnel.*;	/**	 * This is the class to express an analog accelerometer	 * 	 * @author Shigeru Kobayashi	 */	public class Accelerometer extends PhysicalInput {		public static const X_AXIS:uint = 0;		public static const Y_AXIS:uint = 1;		public static const Z_AXIS:uint = 2;		private var _xPin:Pin = null;		private var _yPin:Pin = null;		private var _zPin:Pin = null;		private var _x:Number = 0;		private var _y:Number = 0;		private var _z:Number = 0;		private var _smoothing:Boolean = false;				private var _dynamicRange:Number;		/**		 * 		 * @param xPin the pin number of the x-axis pin		 * @param yPin the pin number of the y-axis pin		 * @param zPin the pin number of the z-axis pin		 * @param smoothing enable smoothing (defailt is true)		 * @throws (newArgumentError("At least one axis should be NOT null"))		 */		public function Accelerometer(xPin:Pin, yPin:Pin, zPin:Pin, smoothing:Boolean = true) {			super();			if (xPin == null && yPin == null && zPin == null) {				throw(new ArgumentError("At least one axis should be NOT null"));			}			_xPin = xPin;			_yPin = yPin;			_zPin = zPin;			_smoothing = smoothing;			if (_xPin != null) {				_xPin.addEventListener(PinEvent.CHANGE, xAxisChanged);			}			if (_yPin != null) {				_yPin.addEventListener(PinEvent.CHANGE, yAxisChanged);			}			if (_zPin != null) {				_zPin.addEventListener(PinEvent.CHANGE, zAxisChanged);			}		}		/**		 * 		 * @param axis the axis to set new range (X_AXIS, Y_AXIS or Z_AXIS)		 * @param minimum the new minimum value		 * @param maximum the new maximum value		 * @param range the range of the sensor in Gs		 */		public function setRangeFor(axis:uint, minimum:Number, maximum:Number, range:Number = 1):void {			_dynamicRange = range;			if (axis == X_AXIS) {				if (_xPin != null) {					_xPin.filters = [new Scaler(minimum, maximum, -range, range, Scaler.LINEAR)];					if (_smoothing) {						_xPin.addFilter(new Convolution(Convolution.MOVING_AVERAGE));					}				}			} else if (axis == Y_AXIS) {				if (_yPin != null) {					_yPin.filters = [new Scaler(minimum, maximum, -range, range, Scaler.LINEAR)];					if (_smoothing) {						_yPin.addFilter(new Convolution(Convolution.MOVING_AVERAGE));					}				}			} else if (axis == Z_AXIS) {				if (_zPin != null) {					_zPin.filters = [new Scaler(minimum, maximum, -range, range, Scaler.LINEAR)];					if (_smoothing) {						_zPin.addFilter(new Convolution(Convolution.MOVING_AVERAGE));					}				}			}		}				/**		 * The dynamic range of the accelerometer in units of gravity (9.8 m/sec2)		 *		 * @return		 */		public function get dynamicRange():Number {			return _dynamicRange;		}		/**		 * 		 * @return 		 */		public function get x():Number {			return _x;		}		/**		 * 		 * @return 		 */		public function get y():Number {			return _y;		}		/**		 * 		 * @return 		 */		public function get z():Number {			return _z;		}		/**		 * 		 * @return 		 */		public function get rotationX():Number {			var sinX:Number = Math.min(Math.max(_x, -1), 1);			return Math.asin(sinX) / Math.PI * 180;		}		/**		 * 		 * @return 		 */		public function get rotationY():Number {			var sinY:Number = Math.min(Math.max(_y, -1), 1);			return Math.asin(sinY) / Math.PI * 180;		}		/**		 * 		 * @return 		 */		public function get rotationZ():Number {			var sinZ:Number = Math.min(Math.max(_z, -1), 1);			return Math.asin(sinZ) / Math.PI * 180;		}		private function xAxisChanged(e:PinEvent):void {			_x = e.target.value;			dispatchEvent(new Event(Event.CHANGE));		}		private function yAxisChanged(e:PinEvent):void {			_y = e.target.value;			dispatchEvent(new Event(Event.CHANGE));		}		private function zAxisChanged(e:PinEvent):void {			_z = e.target.value;			dispatchEvent(new Event(Event.CHANGE));		}	}}