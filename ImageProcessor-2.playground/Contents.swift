import UIKit

//NOTE: The code is written in Swift 3.0. Use Xcode-8 to execute the code.

//Filters that can be applied - Grayscale, Negative, Brightness, Reddish, Greenish, Blueish, Contrast

//Original Image
let image = UIImage(named: "sample")!

//Applying default filters to original image
//let grayScaleDefaultImage = image.applyDefaultFilter(filterType: .GrayScale)
//let negativeDefaultImage = image.applyDefaultFilter(filterType: .Negative)
//let brightDefaultImage = image.applyDefaultFilter(filterType: .Brightness)
//let reddishDefaultImage = image.applyDefaultFilter(filterType: .Reddish)
//let greenishDefaultImage = image.applyDefaultFilter(filterType: .Greenish)
//let blueishDefaultImage = image.applyDefaultFilter(filterType: .Blueish)
//let contrastDefaultImage = image.applyDefaultFilter(filterType: .Contrast)


//Applying filters with parameters to Original Image
//let grayScaleImage = image.applyFilter(filterType: .GrayScale, withParameter: 0)
let negativeImage = image.applyFilter(filterType: .Negative, withParameter: 200)
//let brightImage = image.applyFilter(filterType: .Brightness, withParameter: 20)
//let reddishImage = image.applyFilter(filterType: .Reddish, withParameter: 2)
//let greenishImage = image.applyFilter(filterType: .Greenish, withParameter: 5)
//let blueishImage = image.applyFilter(filterType: .Blueish, withParameter: 2)
//let contrastImage = image.applyFilter(filterType: .Contrast, withParameter: 3.0)
//
//
////Applying filters in a specific order to original image
//let filteredImage1 = image.applyFiltersInOrder(filters: [(.Reddish,3),(.Brightness,20)])
//let filteredImage2 = image.applyFiltersInOrder(filters: [(.GrayScale,10),(.Contrast,0.5)])
//let filteredImage3 = image.applyFiltersInOrder(filters: [(.Negative,150),(.Contrast,2.0)])
