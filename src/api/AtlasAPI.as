/**
 * Created by agnither on 13.02.14.
 */
package api {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import starling.events.EventDispatcher;

public class AtlasAPI extends EventDispatcher{

    public static const RESPONSE: String = "response_AtlasAPI";

    public static const CHANNELS: String = "channels.json";
    public static const SCHEDULE: String = "schedule.json";
    public static const SEARCH: String = "search.json";
    public static const CONTENT: String = "content.json";

    private static var url: String = "https://atlas.metabroadcast.com/3.0/";

    private var _loader: URLLoader;

    private var _stack: Vector.<URLRequest>;
    private var _current: URLRequest;

    public function AtlasAPI() {
        _loader = new URLLoader();
        _loader.addEventListener(Event.COMPLETE, handleComplete);

        _stack = new <URLRequest>[];
    }

    public function getChannels(broadcaster: String = "", media_type: String = "", available_from: String = "", order_by: String = "", limit: int = 5, offset: int = 0, annotations: String = ""):void {
        var data: Object = {};
        data.broadcaster = broadcaster;
        data.media_type = media_type;
        data.available_from = available_from;
        data.order_by = order_by;
        data.limit = limit;
        data.offset = offset;
        data.annotations = annotations;
        var request: URLRequest = getURLRequest(CHANNELS, data);
        sendRequest(request);
    }

    public function getSchedule(channel_id: String, publisher: String = "", from: String = "", to: String = "", annotations: String = ""):void {
        var data: Object = {};
        data.channel_id = channel_id;
        data.publisher = publisher;
        data.from = from;
        data.to = to;
        data.annotations = annotations;
        var request: URLRequest = getURLRequest(SCHEDULE, data);
        sendRequest(request);
    }

    public function search(q: String, limit: int = 5, publisher: String = null):void {
        var data: Object = {};
        data.q = q;
        data.limit = limit;
        if (publisher) {
            data.publisher = publisher;
        }
        var request: URLRequest = getURLRequest(SEARCH, data);
        sendRequest(request);
    }

    public function getContent(uri: String, annotations: String = null):void {
        var data: Object = {};
        data.uri = uri;
        if (annotations) {
            data.annotations = annotations;
        }
        var request: URLRequest = getURLRequest(CONTENT, data);
        sendRequest(request);
    }

    private function sendRequest(request: URLRequest):void {
        if (_current) {
            _stack.push(request);
        } else {
            _current = request;
            _loader.load(_current);
        }
    }

    private function handleComplete(e: Event):void {
        var data: Object = JSON.parse(_loader.data);
        data.method = _current.url.replace(url, "");
        dispatchEventWith(RESPONSE, false, data);

        _current = null;
        if (_stack.length>0) {
            sendRequest(_stack.shift());
        }
    }

    [Inline]
    private static function getURLRequest(method: String, data: Object):URLRequest {
        var vars: URLVariables = new URLVariables();
        if (data) {
            for (var key: String in data) {
                vars[key] = data[key];
            }
        }

        var request: URLRequest = new URLRequest(url+method);
        request.method = URLRequestMethod.GET;
        request.data = vars;
        return request;
    }
}
}
