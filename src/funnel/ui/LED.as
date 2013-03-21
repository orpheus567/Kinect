﻿package funnel.ui {	import funnel.*;	/**	 * This is the class to express a LED	 * 	 * @author Shigeru Kobayshi	 */	public class LED {		public static const SOURCE_DRIVE:uint = 0;		public static const SYNC_DRIVE:uint = 1;		private var _pin:Pin;		private var _onValue:Number = 1;		private var _offValue:Number = 0;		private var _driveMode:uint;		/**		 * 		 * @param ledPin		 * @param driveMode		 * @throws (newArgumentError("driveMode should be SOURCE_DRIVE or SYNC_DRIVE"))		 */		public function LED(ledPin:Pin, driveMode:uint = SOURCE_DRIVE) {			_pin = ledPin;			_driveMode = driveMode;						if (_driveMode == SOURCE_DRIVE) {				_onValue = 1;				_offValue = 0;			} else if (_driveMode == SYNC_DRIVE) {				_onValue = 0;				_offValue = 1;			} else {				throw(new ArgumentError("driveMode should be SOURCE_DRIVE or SYNC_DRIVE"));			}		}		/**		 * 		 * @return the current value (intensity)		 */		public function get value():Number {			return _pin.value;		}		/**		 * 		 * @param val the new value (intensity) to set		 */		public function set value(val:Number):void {			if (_driveMode == SOURCE_DRIVE) {				_pin.value = val;			} else if (_driveMode == SYNC_DRIVE) {				_pin.value = 1 - val;			}		}		/**		 * 		 * @return the current intensity		 */		public function get intensity():Number {			return value;		}		/**		 * 		 * @param val the new intensity to set		 */		public function set intensity(val:Number):void {			value = val;		}		/**		 * 		 */		public function on():void {			_pin.value = _onValue;		}		/**		 * 		 */		public function off():void {			_pin.value = _offValue;		}		/**		 * 		 * @return the LED is turned on or not		 */		public function isOn():Boolean {			return _pin.value == _onValue;		}		/**		 * 		 */		public function toogle():void {			_pin.value = 1 - _pin.value;		}		/**		 * 		 * @param interval the time interval		 * @param times the times of blink		 * @param wave the wave (default is Osc.SQUARE)		 * @see Osc		 */		public function blink(interval:Number, times:Number = 1, wave:Function = null):void {			var freq:Number = 1000 / interval;			if (wave == null) {				wave = Osc.SQUARE;			}			_pin.setFilters([new Osc(wave, freq, 1, 0, 0, times)]);			_pin.filters[0].start();		}		/**		 * 		 */		public function stopBlinking():void {			if (_pin.filters[0] != null) {				_pin.filters[0].stop();			}			_pin.value = 0;		}		/**		 * 		 * @param time the fade-in time (in milliseconds)		 */		public function fadeIn(time:Number = 1000):void {			fadeTo(1, time);		}		/**		 * 		 * @param time the fade-in time (in milliseconds)		 */		public function fadeOut(time:Number = 1000):void {			fadeTo(0, time);		}		/**		 * 		 * @param to the new intensity to fade		 * @param time the fade time (in milliseconds)		 */		public function fadeTo(to:Number, time:Number = 1000):void {			var freq:Number = 1000 / time;			if (_pin.value != to) {				_pin.filters = [new Osc(Osc.LINEAR, freq, to - _pin.value, _pin.value, 0, 1)];				_pin.filters[0].start();			} else {				_pin.filters = null;			}		}	}}