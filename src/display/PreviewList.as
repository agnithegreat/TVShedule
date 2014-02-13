/**
 * Created by agnither on 13.02.14.
 */
package display {
import dataVO.EpisodeVO;

import flash.geom.Point;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import ui.AbstractView;

public class PreviewList extends AbstractView {

    public static const SELECT: String = "select_PreviewList";

    public static var gap: int = 10;

    private var _width: int;
    private var _height: int;

    private var _list: Vector.<Preview>;
    public function get amount():int {
        return _list.length;
    }

    private var _current: int;
    public function get current():Preview {
        return _list[_current];
    }

    private var _dragStart: Point;

    public function PreviewList(width: int, height: int) {
        _width = width;
        _height = height;

        _list = new <Preview>[];

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    public function addPreview(data: EpisodeVO):void {
        var preview: Preview = new Preview(data, _width, _height);
        preview.addEventListener(Preview.TAP, handleTap);
        addChild(preview);
        _list.push(preview);

        update();
    }

    private function update():void {
        var l: int = _list.length;
        for (var i:int = 0; i < l; i++) {
            _list[i].x = i * (_width+gap);
        }
    }

    public function select(index: int):void {
        _current = index;

        var l: int = _list.length;
        for (var i:int = 0; i < l; i++) {
            _list[i].selected = i==_current;
        }

        dispatchEventWith(SELECT);
    }

    public function handleTap(e: Event):void {
        var selected: Preview = e.currentTarget as Preview;
        var index: int = _list.indexOf(selected);
        select(index);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(stage);
        if (touch) {
            var delta: Point = touch.getMovement(stage);
            var position: Point = touch.getLocation(stage);
            switch (touch.phase) {
                case TouchPhase.BEGAN:
                    _dragStart = position;
                    Preview.locked = false;
                    break;
                case TouchPhase.MOVED:
                    pivotX -= delta.x;
                    pivotX = Math.max(0, Math.min(pivotX, x + width-stage.stageWidth));
                    if (Point.distance(_dragStart, position) > 10) {
                        Preview.locked = true;
                    }
                    break;
                case TouchPhase.ENDED:
                    pivotX = int(pivotX);
                    break;
            }
        }
    }
}
}
