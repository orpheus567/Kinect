package
{
	import com.as3nui.nativeExtensions.air.kinect.examples.basic.BasicDemo;
	
	import flash.display.Sprite;
	
	import funnel.Arduino;
	import funnel.Configuration;
	import funnel.SERVO;
	import funnel.ui.Servo;

	[SWF(frameRate="10", width="1024", height="500", backgroundColor="#FFFFFF")]
	public class KinectTest extends BasicDemo
	{
		private var arduino:Arduino;
		private var servo:Servo;
		public function KinectTest()
		{
			var config:Configuration = Arduino.FIRMATA;
			config.setDigitalPinMode(9,SERVO);
			arduino = new Arduino(config);
			
			servo = new Servo(arduino.digitalPin(9));
		}
		
		override protected function changeDepthX(numX:Number):void
		{
			//150-700
			//550
			var ratio:Number = (numX-130)/550;
			if(ratio<0){
				ratio = 0;
			}
			if(ratio>1){
				ratio = 1;
			}
//			var tr:int = 130-(int((int(120*ratio)+10)*.1)*10);
			var tr:int = 130-int((120*ratio)+10);
			servo.angle = tr;
			
		}
		
	}
}