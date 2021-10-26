# MarvelAPITest

This is a technical test that, with a 1-week time limit, demonstrates current knowledge of iOS development. 

It uses Swift, UIKit and Combine, communicating with [Marvel's API](https://developer.marvel.com/docs) using a simple URLSession.
Unit tests are used for guaranteeing that proper decoding of the JSON responses was done successfully.

## Implementation

Everything has been done mostly ensuring only references to protocols were stored, leaving room for reusability and free configuration.

The pattern followed for the screens is MVP, creating models that have original raw data models and their mapped data ready to be sent to the views. This allows the view to only know about view-related info, and all product-related logic is done in the presenters.

The service layer has been divided in two classes: Service and API. The Service uses the API class to perform the request and the decoding, it is the service who is in charge of deciding what to do with the result. Also, all accesses to the Service methods (through the protocol) are done strictly through UseCases dedicated to singular request types. This helps testing (even though there was no time to do so).

The screens consisted in two View Controllers:

  - The first one presents the list of characters, loading paged data whenever it was required. The list of characters displays the thumbnail image of each
    character alongside their name. The load of the image is done using SDWebImage since it helps with asynchronous loads. Getting an error in the first page of
    content will display a popup to retry.
    
  - The second one, only accessed when tapping on a character, performs a request with that specific character ID. Getting any error will display a popup and return     the user to the character list. The details screen has a dynamic scrollable list of information, adding subviews that calculate their own height and the height
    of their inner subviews to be able to display the data accordingly when asking for the height of the content from the top view.

## Notes

I wanted to point out that, since the technical test specified to use the endpoint to get the character list and the endpoint to get the character details using their ID __SEPARATELY__, we did so, but the API already returns (at least if I'm not mistaken) the full details of the character when retrieving the list (since it is supposed to be using the same procedure to populate each response, just with different number of characters in the list of results). Therefore, we could be navigating to the character details with the information we already had while displaying the characters list, and we have code that supports that (check GetPreloadedCharacter) and both can be used just by changing the UseCase to use since they implement the same protocol. 

## Libraries used

- [SDWebImage](https://github.com/SDWebImage/SDWebImage)

## What was intended to be added with more time

There are a few things that could have been added to the project, but they weren't due to the lack of time, so I prioritized the final graphical result.
If there was more time, I would have added:
  - [KIF](https://github.com/kif-framework/KIF) for testing purposes
  - UITests 
  - [Alamofire](https://github.com/Alamofire/Alamofire) to make use of networking utilities
  - Response caching
  - More specific Error handling
