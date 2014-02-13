/**
 * Created by agnither on 13.02.14.
 */
package {
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import starling.textures.Texture;

public class ImageLoader {

    public static var cache: Dictionary = new Dictionary();
    public static function load(url: String, callback: Function):void {
        new ImageLoader(url, callback);
    }

    private var _loader: Loader;
    private var _url: String;
    private var _callback: Function;

    public function ImageLoader(url: String, callback: Function) {
        _callback = callback;
        _url = url;
        if (!cache[_url]) {
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
            _loader.load(new URLRequest(url));
            cache[_url] = _loader;
        } else {
            if (cache[_url] is Loader) {
                _loader = cache[_url];
                _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
            } else {
                _callback(cache[_url]);
            }
        }
    }

    private function handleComplete(e: Event):void {
        _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);

        if (cache[_url] is Loader) {
            var image: Bitmap = _loader.content as Bitmap;
            cache[_url] = Texture.fromBitmap(image, false);

            image.bitmapData.dispose();
            image.bitmapData = null;
            image = null;
        }
        _callback(cache[_url]);

        _loader = null;
        _url = null;
        _callback = null;
    }
}
}
