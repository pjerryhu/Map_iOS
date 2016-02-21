
# Map_iOS

Update 2/20 Saturday:

IntersectionForServer variable is being prepared for Server usage, 
it's of the form [[latitude1, longitude1], [latitude2, longitude2]...]

There are three labels below mapView, upperleft one gives current address,
lowerLeft one tells you whether you are in the intersection(or a NewIntersection) or not,
Last label is the count of intersections been thru (IntersectionForServer.count).

You have to press button start to start recording (polylining), then the map will start counting intersections as well.
Once you press finish, all the previous data will be wiped out, it is assumed that this app will upload data to server first.

For collaborators: please modify function FinishRecording to add client-server interaction functionality.

//
Tips for simulation from 2/15:

Once the simulator is up and running, you can click on the American Flag, and then hit the stop button to login the MapView.
Once you are in the map view use debug option in the menu bar to set the location manually. 
For custom location, I suggest you use the commented out location, which is the intersection of College Ave and Boston Ave.

Once you see the beacon in the MapView, you can then hit the button on the button of the simulator next to the 
plus sign. It manually tells the app to print out all attributes of that GeoLocation.



Note: 
use this website in simulation to mannually log in address for testing
http://www.gps-coordinates.net/ 
