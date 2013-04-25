package com.as3nui.nativeExtensions.air.kinect.examples.skeleton
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.as3nui.nativeExtensions.air.kinect.examples.DemoBase;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class SkeletonJointsDemo extends DemoBase
	{
		public static const KinectMaxDepthInFlash:uint = 200;
		
		protected var device:Kinect;
		private var skeletonRenderers:Vector.<SkeletonRenderer>;
		private var skeletonContainer:Sprite;
		private var $cnt:int=0;
		
		override protected function startDemoImplementation():void
		{
			if(Kinect.isSupported())
			{
				device = Kinect.getDevice();

				var settings:KinectSettings = new KinectSettings();
				settings.skeletonEnabled = true;
				settings.skeletonMirrored = true;
//				settings.
//				device.addEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, skeletonsAddedHandler, false, 0, true);
//				device.addEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, skeletonsRemovedHandler, false, 0, true);
				device.addEventListener(UserEvent.USERS_ADDED,skeletonsAddedHandler);
				device.addEventListener(UserEvent.USERS_REMOVED,skeletonsRemovedHandler);
				
				skeletonRenderers = new Vector.<SkeletonRenderer>();
				skeletonContainer = new Sprite();
				addChild(skeletonContainer);
				
				addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
				device.start(settings);
			}
		}
		
		protected function userAdded(event:UserEvent):void
		{
			// TODO Auto-generated method stub
			trace("사용자 추가");
		}
		
		protected function skeletonsRemovedHandler2(event:UserEvent):void
		{
			// TODO Auto-generated method stub
			
			trace("사용자 지우기11111111");
		}
		
		protected function skeletonsRemovedHandler(event:UserEvent):void
		{
			trace("사용자 지우기000000000");
				
			for each(var removedUser:User in event.users)
			{
				var index:int = -1;
					trace("event.users.length: ",event.users.length);
					trace("skeletonRenderers.length: ",skeletonRenderers.length);
				for(var i:int = 0; i < skeletonRenderers.length; i++)
				{
					trace("i: ",i);
					trace("removedUser.userID: ",removedUser.userID);
					trace("skeletonRenderers[i].user.userID: ",skeletonRenderers[i].user.userID);
					if(skeletonRenderers[i].user.userID == removedUser.userID)
					{
						index = i;
						trace("인덱스번호: ",index);
						break;
					}
				}
				if(index > -1)
				{
					skeletonContainer.removeChild(skeletonRenderers[index]);
					skeletonRenderers.splice(index, 1);
				}
			}
		}
		
		protected function skeletonsAddedHandler(event:UserEvent):void
		{
			for each(var addedUser:User in event.users)
			{
				$cnt++;
				var skeletonRenderer:SkeletonRenderer = new SkeletonRenderer(addedUser);
				trace("사용자 아이디: ",addedUser.userID);
				skeletonRenderer.name = "mc"+$cnt;
				skeletonContainer.addChild(skeletonRenderer);
				skeletonRenderers.push(skeletonRenderer);
			}
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			trace("감지된 사람수: ",device.users.length);
			for each(var skeletonRenderer:SkeletonRenderer in skeletonRenderers)
			{
				skeletonRenderer.explicitWidth = explicitWidth;
				skeletonRenderer.explicitHeight = explicitHeight;
				skeletonRenderer.render();
			}
		}
		
		override protected function stopDemoImplementation():void
		{
			if(device != null)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				device.removeEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, skeletonsAddedHandler);
				device.removeEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, skeletonsRemovedHandler);
				device.stop();
			}
		}
		
		override protected function layout():void
		{
			if (skeletonContainer != null)
			{
				
			}
			if (root != null)
			{
				root.transform.perspectiveProjection.projectionCenter = new Point(explicitWidth * .5, explicitHeight * .5);
			}
		}
	}
}

import away3d.cameras.SpringCam;

import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
import com.as3nui.nativeExtensions.air.kinect.data.User;
import com.bit101.components.Label;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

internal class SkeletonRenderer extends Sprite
{
	
	public var user:User;
	private var labels:Vector.<Label>;
	private var circles:Vector.<Sprite>;

	public var explicitWidth:uint;
	public var explicitHeight:uint;
	
	public function SkeletonRenderer(user:User)
	{
		this.user = user;
		labels = new Vector.<Label>();
		circles = new Vector.<Sprite>();
		addEventListener(MouseEvent.CLICK,onClick);
	}
	private function onClick(event:MouseEvent):void{
		var mc:Sprite = event.currentTarget as Sprite;
		trace("이름: ",mc.name);
	}
	
	private function createLabelsIfNeeded():void
	{
		while(labels.length < user.skeletonJoints.length)
		{
			labels.push(new Label(this));
		}
	}
	
	private function createCirclesIfNeeded():void
	{
		while(circles.length < user.skeletonJoints.length)
		{
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(0xff0000);
			circle.graphics.drawCircle(0, 0, 10);
			circle.graphics.endFill();
			addChild(circle);
			circles.push(circle);
		}
	}
	
	public function render():void
	{
		graphics.clear();
		var numJoints:uint = user.skeletonJoints.length;
		//create labels
		createLabelsIfNeeded();
		createCirclesIfNeeded();
		for(var i:int = 0; i < numJoints; i++)
		{
			var joint:SkeletonJoint = user.skeletonJoints[i];
			var label:Label = labels[i];
			var circle:Sprite = circles[i];
			//circle
			circle.x = joint.position.depthRelative.x * explicitWidth;
			circle.y = joint.position.depthRelative.y * explicitHeight;
			//label
			label.text = joint.name;
			label.x = circle.x;
			label.y = circle.y;
		}
	}
}