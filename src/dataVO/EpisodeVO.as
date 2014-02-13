/**
 * Created by agnither on 13.02.14.
 */
package dataVO {
import com.adobe.utils.DateUtil;

public class EpisodeVO {

    public var title: String;
    public var description: String;
    public var image: String;
    public var thumbnail: String;
    public var transmissionStart: Date;
    public var transmissionEnd: Date;
    public var daysRemaining: int;
    public var available: Boolean;

    public function EpisodeVO(data: Object) {
        title = data.title;
        description = data.description;
        image = data.image;
        thumbnail = data.thumbnail;

        var now: Date = new Date();

        var l: int = data.broadcasts.length;
        for (var i:int = 0; i < l; i++) {
            var date: Date = DateUtil.parseW3CDTF(data.broadcasts[i].transmission_time);
            if (!transmissionStart || transmissionStart.time > date.time) {
                transmissionStart = date;
            }
        }
        available = transmissionStart && transmissionStart.time < now.time;

        l = data.locations.length;
        for (i = 0; i < l; i++) {
            date = DateUtil.parseW3CDTF(data.locations[i].availability_end);
            if (!transmissionEnd || transmissionEnd.time < date.time) {
                transmissionEnd = date;
            }
        }
        daysRemaining = transmissionEnd ? (transmissionEnd.time - now.time) / (1000*60*60*24) : -1;
    }
}
}
