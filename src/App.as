/**
 * Created by agnither on 13.02.14.
 */
package {
import starling.display.Sprite;
import starling.events.Event;

public class App extends Sprite {

    private var _controller: Controller;

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
    }

    private function handleAdded(e: Event):void {
        _controller = new Controller(stage);
        _controller.init();
    }
}
}
