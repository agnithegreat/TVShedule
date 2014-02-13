/**
 * Created by agnither on 13.02.14.
 */
package {
import api.AtlasAPI;

import dataVO.EpisodeVO;

import display.Screen;

import starling.display.Stage;

import starling.events.Event;
import starling.events.EventDispatcher;

public class Controller extends EventDispatcher {

    public static const INIT: String = "init_Controller";

    private var _api: AtlasAPI;

    private var _episodesCount: int;
    private var _episodes: Vector.<EpisodeVO>;
    public function get episodes():Vector.<EpisodeVO> {
        return _episodes;
    }

    private var _stage: Stage;
    private var _view: Screen;

    public function Controller(stage: Stage) {
        _stage = stage;

        _api = new AtlasAPI();
        _api.addEventListener(AtlasAPI.RESPONSE, handleResponse);

        _view = new Screen(this);
        _stage.addChild(_view);
    }

    public function init():void {
        _episodes = new <EpisodeVO>[];

        _api.search("Ludus", 5, "bbc.co.uk");
    }

    private function handleResponse(e: Event):void {
        var response: Object = e.data;
        switch (response.method) {
            case AtlasAPI.CHANNELS:
                break;
            case AtlasAPI.SCHEDULE:
                break;
            case AtlasAPI.SEARCH:
                parseSearch(response);
                break;
            case AtlasAPI.CONTENT:
                parseContent(response);
                break;
        }
    }

    private function parseSearch(data: Object):void {
        var episodes: Array = data.contents[0].content;
        _episodesCount = episodes.length;
        for (var i:int = 0; i < _episodesCount; i++) {
            _api.getContent(episodes[i].uri);
        }
    }

    private function parseContent(data: Object):void {
        var episode: EpisodeVO = new EpisodeVO(data.contents[0]);
        _episodes.push(episode);

        if (_episodes.length == _episodesCount) {
            dispatchEventWith(INIT);
        }
    }
}
}
