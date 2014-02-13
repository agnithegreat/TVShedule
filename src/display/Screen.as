/**
 * Created by agnither on 13.02.14.
 */
package display {
import starling.events.Event;
import starling.text.TextField;
import starling.utils.HAlign;

import ui.AbstractView;

public class Screen extends AbstractView {

    private var _controller: Controller;

    private var _bg: Picture;

    private var _main: Picture;

    private var _label: TextField;
    private var _list: PreviewList;

    public function Screen(controller: Controller) {
        _controller = controller;
        _controller.addEventListener(Controller.INIT, handleInit);
    }

    override protected function initialize():void {
        _bg = new Picture(stage.stageWidth, stage.stageHeight, true);
        _bg.alpha = 0.15;
        addChild(_bg);

        _label = new TextField(stage.stageWidth, 34, "", "Verdana", 16, 0xFFFFFF, true);
        _label.hAlign = HAlign.LEFT;
        _label.x = 10;
        _label.y = stage.stageHeight-170;
        addChild(_label);

        _list = new PreviewList(225, 126);
        _list.addEventListener(PreviewList.SELECT, handleSelect);
        _list.x = 10;
        _list.y = stage.stageHeight-136;
        addChild(_list);

        _main = new Picture(384, 216);
        _main.pivotX = _main.width/2;
        _main.pivotY = _main.height/2;
        _main.x = stage.stageWidth/2;
        _main.y = _list.y/2;
        addChild(_main);
    }

    private function handleInit(e: Event):void {
        var l: int = _controller.episodes.length;
        for (var i:int = 0; i < l; i++) {
            if (_controller.episodes[i].available) {
                _list.addPreview(_controller.episodes[i]);
            }
        }
        _label.text = String(_list.amount)+" episodes available";
        _list.select(0);
    }

    private function handleSelect(e: Event):void {
        _bg.load(_list.current.data.image);
        _main.load(_list.current.data.image);
    }
}
}
