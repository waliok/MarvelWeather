# MarvelWeather

iOS Application based on SwiftUI framework. 

## Main functionality

* On main screen fetching current weather data for for current location.
* Use list of favourite places to follow changes when you need it.
* Open the map and give a point to fetch current weather information for axact latitude and longitude.
* Editd your list of follows: delete unnecessary and add desired.
* Change measurement units between fahrnheit an celsium.

## Feature and tech overview

* Using OpenWeather API to fetch current weather. Decode JSON response data and display on screen.
* Determine current user location with CoreLocation functionality.
* Decode coordinate(longitude and latitude) to display actual adress(shorted to show city name).
* Show MapView powered by Mapkit to find disered location on map.
* Using CoreData for persis locations of favourite places to follow weater.
* Add pakege dependency(BottomSheet) to implement bottom sheet functionality for iOS under iOS 16.
* Use converted from SVG code to draw shapes.
* Create custom element like TabBar, NavigationBar and other more.
* Create smooth transition animation with geometry reader detection.
* Use Async/Await syntax to treat necessary tasks on backgroud and back to MainActor for update UI elements.
* Add peace of Combine framework functionality to search bar.
* Add some snow animation with SpriteKit Scene, just for to emphasize the overall atmosphere and theme of app.
 

https://user-images.githubusercontent.com/105702456/232889977-ed724199-d6f4-4318-8544-357a1a30e6fd.mp4
https://user-images.githubusercontent.com/105702456/232890032-b97e778e-48f9-43bf-90d2-f455c4a6f9ab.mp4


https://user-images.githubusercontent.com/105702456/232890092-755628da-6a31-46ac-b90a-64bf613eef6d.mp4
https://user-images.githubusercontent.com/105702456/232890131-55b3000a-31e8-4b58-b8da-16b6e6e2df81.mp4

<!-- 
.gallery {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
    width: 100%;
}

video {
  display: block;
  width: 100%;
}


<div class="gallery">
  <video controls>
    <source src="https://user-images.githubusercontent.com/105702456/232889977-ed724199-d6f4-4318-8544-357a1a30e6fd.mp4" type="video/mp4" >
  </video>
  <video controls>
    <source src="https://user-images.githubusercontent.com/105702456/232890032-b97e778e-48f9-43bf-90d2-f455c4a6f9ab.mp4" type="video/mp4">
  </video>
  <video controls>
    <source src="https://user-images.githubusercontent.com/105702456/232890092-755628da-6a31-46ac-b90a-64bf613eef6d.mp4" type="video/mp4">
  </video>
 video controls>
    <source src="https://user-images.githubusercontent.com/105702456/232890131-55b3000a-31e8-4b58-b8da-16b6e6e2df81.mp4" type="video/mp4">
  </video>
</div>
 -->
