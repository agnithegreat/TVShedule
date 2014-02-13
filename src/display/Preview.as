/**
 * Created by agnither on 13.02.14.
 */
package display {
import dataVO.EpisodeVO;

import starling.display.Quad;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.HAlign;

import ui.AbstractView;

public class Preview extends AbstractView {

    public static const TAP: String = "tap_Preview";

    public static var locked: Boolean;

    private var _data: EpisodeVO;
    public function get data():EpisodeVO {
        return _data;
    }

    private var _frame: Quad;
    private var _picture: Picture;

    private var _label: Quad;
    private var _title: TextField;
    private var _time: TextField;

    public function get texture():Texture {
        return _picture.texture;
    }

    public function set selected(value: Boolean):void {
        _frame.visible = value;
    }
    public function get selected():Boolean {
        return _frame.visible;
    }

    public function Preview(data: EpisodeVO, width: int, height: int) {
        _data = data;

        _frame = new Quad(width+10, height+10, 0xc1ce0a);
        _frame.visible = false;
        _frame.x = -5;
        _frame.y = -5;
        addChild(_frame);

        _picture = new Picture(width, height);
        _picture.load(data.image);
        addChild(_picture);

        _label = new Quad(width, 40, 0);
        _label.y = height-40;
        _label.alpha = 0.7;
        addChild(_label);

        _title = new TextField(width, 20, _data.title, "Verdana", 12, 0xc1ce0a);
        _title.hAlign = HAlign.LEFT;
        _title.x = 10;
        _title.y = height-40;
        addChild(_title);

        _time = new TextField(width, 20, "", "Verdana", 12, 0xFFFFFF, true);
        _time.text = _data.daysRemaining>=0 ? String(_data.daysRemaining)+" days remaining" : "Broadcast unavailable";
        _time.hAlign = HAlign.LEFT;
        _time.x = 10;
        _time.y = height-20;
        addChild(_time);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this);
        if (!locked && touch) {
            switch (touch.phase) {
                case TouchPhase.ENDED:
                    dispatchEventWith(TAP);
                    break;
            }
        }
    }
}
}
