package {
import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;

[SWF(frameRate="60", width="800", height="480", backgroundColor="0")]
public class Main extends Sprite {

    private var _starling: Starling;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        var ios: Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        var android: Boolean = Capabilities.manufacturer.indexOf("Android") != -1;
        var mobile: Boolean = ios || android;
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = !ios;

        var viewport: Rectangle = mobile ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

        _starling = new Starling(App, stage, viewport);
        _starling.stage.stageWidth = viewport.width;
        _starling.stage.stageHeight = viewport.height;

        NativeApplication.nativeApplication.addEventListener(
            Event.ACTIVATE, function (e:*):void {
                _starling.start();
            }
        );

        NativeApplication.nativeApplication.addEventListener(
            Event.DEACTIVATE, function (e:*):void {
                _starling.stop();
            }
        );
    }
}
}
