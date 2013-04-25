package
{
	import away3d.cameras.SpringCam;
	
	import com.as3nui.nativeExtensions.air.kinect.examples.basic.BasicDemo;
	import com.as3nui.nativeExtensions.air.kinect.examples.cameras.RGBCameraDemo;
	import com.as3nui.nativeExtensions.air.kinect.examples.skeleton.SkeletonBonesDemo;
	import com.as3nui.nativeExtensions.air.kinect.examples.skeleton.SkeletonJointsDemo;
	import com.as3nui.nativeExtensions.air.kinect.examples.userMask.UserMaskDemo;
	import com.as3nui.nativeExtensions.air.kinect.examples.userMask.UserMaskEnterFrameDemo;
	
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.text.TextField;
	
	import flashx.textLayout.formats.TextAlign;
	
	import orpheus.events.XMLLoaderEvent;
	import orpheus.movieclip.TestButton;
	import orpheus.nets.EncodeType;
	import orpheus.nets.XMLLoader;
	import orpheus.utils.FPSCheck;
	import orpheus.utils.Stats;

		[SWF(frameRate="60", width="1920", height="1080", backgroundColor="#FFFFFF")]
//	public class KinectServoMotorTest extends BasicDemo
	public class KinectServoMotorTest extends SkeletonJointsDemo
//	public class KinectServoMotorTest extends Sprite
	{ 
//		private var arduino:Arduino;
		private var $tf:TextField;
		private var $motorBank:Array = [7,8,9,10];
		private var $servoBank:Array=[];
		private var $motorNum:int = 4;
		private var video:Video;
		private var $stats:Stats;
		private var opts:NativeWindowInitOptions;
		private var win:NativeWindow;
		private var $xmlLoader:XMLLoader;
		public function KinectServoMotorTest()
		{
//			var aaa:Sprite = new Stats;
//			aaa.y = 300;
//			addChild(aaa);
//			$tf = new TextField;
//			$tf.width = 200;
//			$tf.border = true;
//			$tf.x = 200;
//			$tf.y = 300;
//			$tf.scaleX = $tf.scaleY = 3;
//			addChild($tf);
//			
//			var config:Configuration = Arduino.FIRMATA;
//			for (var i:int = 0; i < $motorBank.length; i++) 
//			{
//				config.setDigitalPinMode($motorBank[i],SERVO);
//			}
//			arduino = new Arduino(config);
//
//			for (var j:int = 0; j < $motorBank.length; j++) 
//			{
//				var servo:Servo = new Servo(arduino.digitalPin($motorBank[j]));
//				$servoBank.push(servo);
//			}

		}
		
		protected function xmlLoaded(event:XMLLoaderEvent):void
		{
			// TODO Auto-generated method stub
			$tf.appendText(event.xml);
		}
		
		private function activityHandler(event:ActivityEvent):void {
			trace("activityHandler: " + event);
			super.startDemoImplementation();
		}
		override protected function startDemoImplementation():void
		{
			
			$tf = new TextField;
			$tf.autoSize = TextAlign.LEFT;
			$tf.width  = 500;
			$tf.wordWrap = true;
			$tf.multiline = true;
			$xmlLoader = new XMLLoader;
			$xmlLoader.load("http://oasismaker.com/timo/sample5.php",null,EncodeType.EUC_KR);
			$xmlLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE,xmlLoaded);
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			var camera:Camera = Camera.getCamera();
			camera.setMode(960, 540, 24); 
			camera.setQuality(0,90);
			
			trace("camera: ",camera);
			if (camera != null) {
				camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
				video = new Video(1080, 608);
				video.smoothing = true;
				video.x=500;
				video.attachCamera(camera);
				addChild(video);
				$tf.text = "cccccccccccccccccamera";
			} else {
				$tf.text = "You need a camera";
				trace("You need a camera.");
			}
			$stats = new Stats;
			$stats.y=1000;
			addChild($stats);
			addChild($tf);		
			
			$tf.appendText("super.startDemoImplementation");
			for (var i:int = 0; i < 10; i++) 
			{
				var btn:MovieClip = TestButton.btn();
				btn.y = 1000;
				btn.x = i*50+100;
				btn.myNum = i;
				addChild(btn);
				btn.addEventListener(MouseEvent.CLICK,onClick);
			}			
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:MovieClip = event.currentTarget as MovieClip;
			device.cameraElevationAngle = mc.myNum*10-30;
		}
		
//		override protected function changeDepthX(numX:Number):void
//		{
//			var ratio:Number = (numX-130)/550;
//			if(ratio<0){
//				ratio = 0;
//			}
//			if(ratio>1){
//				ratio = 1;
//			}
//			var tr:int = 110-int((100*ratio)+10);
//			for (var i:int = 0; i < $motorNum; i++) 
//			{
//				var servo:Servo = $servoBank[i];
//				servo.angle = tr;
//			}
//			
			
//		}
		
	}
}