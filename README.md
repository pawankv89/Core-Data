
MKCircle
=========

## Find 500m Range of your current location
------------
 Added Some screens here.
 
[![](https://github.com/pawankv89/MKCircle/blob/master/images/screen_1.PNG)]
[![](https://github.com/pawankv89/MKCircle/blob/master/images/screen_2.PNG)]
[![](https://github.com/pawankv89/MKCircle/blob/master/images/screen_3.PNG)]


## Usage
------------
 You can add this method in your `UICollectionView`.


```objective-c
- (void) loadMapView
{
    CLLocationCoordinate2D objCoor2D = {.latitude = latitude_UserLocation, .longitude = longitude_UserLocation};
    
    //Remove Old OverLay on MAP View
    for (id overlay in objMapView.overlays) {
        if([overlay isKindOfClass:[MKCircle class]]) {
            //Removing past layouts from MapView
            [objMapView removeOverlay:(MKCircle *)overlay];
        }
    }
    
    
    [objMapView setShowsUserLocation:YES];
    [objMapView setDelegate:self ];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:objCoor2D radius:distance];
    [objMapView addOverlay:circle];
    
    //Set Region On MAP View
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(objCoor2D, distance*2,distance*2);
    [objMapView setRegion:region animated:YES];
}
```
 Add MKMapView Delegate 

```objective-c
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor blueColor];
        circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        circleView.lineWidth = 1.0f;
        return circleView;
    }
    return nil;
}
```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each MBProgressHUD release can be found in the [CHANGELOG](CHANGELOG.mdown). 
