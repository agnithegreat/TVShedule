/**
 * Created by agnither on 13.02.14.
 */
package display {
import starling.display.Image;
import starling.textures.Texture;

import ui.AbstractView;

public class Picture extends AbstractView {

    private static var empty: Texture = Texture.fromColor(1, 1, 0xFF000000);

    private var _image: Image;
    public function get texture():Texture {
        return _image.texture;
    }

    private var _proportional: Boolean;

    public function Picture(width: int, height: int, proportional: Boolean = false) {
        _image = new Image(empty);
        _image.width = width;
        _image.height = height;
        addChild(_image);

        _proportional = proportional;
    }

    public function load(url: String):void {
        ImageLoader.load(url, setContent);
    }

    public function setContent(value: Texture):void {
        if (_proportional) {
            var h: int = _image.width/value.width*value.height;
            _image.height = h;
        }
        _image.texture = value;
    }
}
}
