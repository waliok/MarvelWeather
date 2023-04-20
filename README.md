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
 
![1](https://user-images.githubusercontent.com/105702456/233380389-a0fbb6aa-14f6-40e5-8564-a377424343b5.gif)
![2](https://user-images.githubusercontent.com/105702456/233380409-5ef3c141-9cda-4390-be74-3d3b6f8f278d.gif)
![3](https://user-images.githubusercontent.com/105702456/233380428-a494da7b-9a6b-4db5-b136-48ad15f4385e.gif)
![4](https://user-images.githubusercontent.com/105702456/233380450-3548e7eb-6566-4b1e-b6f4-8f7366c4ab8a.gif)
![5](https://user-images.githubusercontent.com/105702456/233380466-5679693a-11df-40a5-9f55-9c651bea5098.gif)

https://user-images.githubusercontent.com/105702456/232918460-19b6feea-60ed-4ded-a045-6836339ff73f.mp4

https://user-images.githubusercontent.com/105702456/232915040-26204f9f-6f76-4023-b49a-33a2d94553cb.mp4

https://user-images.githubusercontent.com/105702456/232915100-c4db90e6-8969-415d-82d4-7e7d2813fe7e.mp4

https://user-images.githubusercontent.com/105702456/232918339-9bbae08c-1b7f-4bc6-af68-17f9e92e957b.mp4
