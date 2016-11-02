import UIKit

/**
 *  @brief This enum specifies different types of filters that can be applied to an image
 */
public enum FilterType : String
{
    case GrayScale
    case Negative
    case Brightness
    case Contrast
    case Reddish
    case Greenish
    case Blueish
    
    func range() -> (minValue : Double, maxValue : Double, currentValue : Double)
    {
        switch self
        {
        case .GrayScale:
            return (-100, 100, 0)
        case .Negative:
            return (0, 10, 5)
        case .Brightness:
            return (-100, 100, 50)
        case .Reddish:
            return (0, 150, 75)
        case .Greenish:
            return (0, 150, 75)
        case .Blueish:
            return (0, 150, 75)
        case .Contrast:
            return (0, 3, 1.2)
        }
    }
}

// MARK: - UIImage extension to apply filter on a UIImage object
public extension UIImage
{
    //Method to apply default filters. The parameters applied to the filtes are default parameters
    public func applyDefaultFilter(filterType : FilterType) -> UIImage
    {
        var rgbaImage = RGBAImage(image: self)!
        switch filterType
        {
        case .GrayScale:
            ImageFilter.grayScaleImage(rgbaImage: &rgbaImage, withParameter: 0)
        case .Negative:
            ImageFilter.negativeImage(rgbaImage: &rgbaImage, withParameter: 5)
        case .Brightness:
            ImageFilter.brightImage(rgbaImage: &rgbaImage, withParameter: 50)
        case .Contrast:
            ImageFilter.contrastImage(rgbaImage: &rgbaImage, withParameter: 1.2)
        case .Reddish:
            ImageFilter.reddishImage(rgbaImage: &rgbaImage, withParameter: 75)
        case .Greenish:
            ImageFilter.greenishImage(rgbaImage: &rgbaImage, withParameter: 75)
        case .Blueish:
            ImageFilter.blueishImage(rgbaImage: &rgbaImage, withParameter: 75)
        }
        return rgbaImage.toUIImage()!
    }
    
    //Method to apply custom filters. The parameters must be provided in order to apply a filter
    public func applyFilter(filterType : FilterType, withParameter parameter : Double) -> UIImage
    {
        var rgbaImage = RGBAImage(image: self)!
        switch filterType
        {
        case .GrayScale:
            ImageFilter.grayScaleImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
        case .Negative:
            ImageFilter.negativeImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
        case .Brightness:
            ImageFilter.brightImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
        case .Contrast:
            ImageFilter.contrastImage(rgbaImage: &rgbaImage, withParameter: parameter)
        case .Reddish:
            ImageFilter.reddishImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
        case .Greenish:
            ImageFilter.greenishImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
        case .Blueish:
            ImageFilter.blueishImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
        }
        return rgbaImage.toUIImage()!
    }

    //Method to apply filters in a specific order. This method will take an array of tuples. A single tuple contains the type of filter to be applied and the corresponding parameter.
    public func applyFiltersInOrder(filters : [(FilterType, Double)]) -> UIImage
    {
        var rgbaImage = RGBAImage(image: self)!
        for (filterType, parameter) in filters
        {
            switch filterType
            {
            case .GrayScale:
                ImageFilter.grayScaleImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
            case .Negative:
                ImageFilter.negativeImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
            case .Brightness:
                ImageFilter.brightImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
            case .Contrast:
                ImageFilter.contrastImage(rgbaImage: &rgbaImage, withParameter: parameter)
            case .Reddish:
                ImageFilter.reddishImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
            case .Greenish:
                ImageFilter.greenishImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
            case .Blueish:
                ImageFilter.blueishImage(rgbaImage: &rgbaImage, withParameter: Int(parameter))
            }
        }
        return rgbaImage.toUIImage()!
    }
}

/**
 *  @brief This struct contains the functionality of applying different filters on the image
 */
struct ImageFilter
{
    //Filter type - Image Contrast
    static func contrastImage( rgbaImage : inout RGBAImage, withParameter parameter : Double)
    {
        let param = Double(max(0, min(3, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                pixel.red = UInt8(max(0, min(255, (param * (Double(pixel.red) - 0.5)) + 0.5)))
                pixel.green = UInt8(max(0, min(255, (param * (Double(pixel.green) - 0.5)) + 0.5)))
                pixel.blue = UInt8(max(0, min(255, (param * (Double(pixel.blue) - 0.5)) + 0.5)))
                
                rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    //Filter type - Grayscale Image
    static func grayScaleImage( rgbaImage : inout RGBAImage, withParameter parameter : Int)
    {
        let param = Int(max(-100, min(100, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let gray = UInt8(max(0, min(255, param + Int(pixel.gray))))
                pixel.red = gray
                pixel.green = gray
                pixel.blue = gray
                
                
                rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    //Filter type - Negative Image
    static func negativeImage( rgbaImage : inout RGBAImage, withParameter parameter : Int)
    {
        let param = Int(max(0, min(10, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                pixel.red = UInt8(max(0, min(255, 255 - param - Int(pixel.red))))
                pixel.green = UInt8(max(0, min(255, 255 - param - Int(pixel.green))))
                pixel.blue = UInt8(max(0, min(255, 255 - param - Int(pixel.blue))))
                
                rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    //Filter type - Image Brightness
    static func brightImage( rgbaImage : inout RGBAImage, withParameter parameter : Int)
    {
        let param = Int(max(-100, min(100, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                pixel.red = UInt8(max(0, min(255, param + Int(pixel.red))))
                pixel.green = UInt8(max(0, min(255, param + Int(pixel.green))))
                pixel.blue = UInt8(max(0, min(255, param + Int(pixel.blue))))
                
                rgbaImage.pixels[index] = pixel
            }
        }
    }

    //Filter type - Reddish Image
    static func reddishImage( rgbaImage : inout RGBAImage, withParameter parameter : Int)
    {
        let param = Int(max(0, min(150, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                pixel.red = UInt8(max(0, min(255, param + Int(pixel.red))))
                rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    //Filter type - Greenish Image
    static func greenishImage( rgbaImage : inout RGBAImage, withParameter parameter : Int)
    {
        let param = Int(max(1, min(5, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                pixel.green = UInt8(max(0, min(255, param + Int(pixel.green))))
                rgbaImage.pixels[index] = pixel

            }
        }
    }
    
    //Filter type - Blueish Image
    static func blueishImage( rgbaImage : inout RGBAImage, withParameter parameter : Int)
    {
        let param = Int(max(1, min(5, parameter)))
        for x in 0..<rgbaImage.width
        {
            for y in 0..<rgbaImage.height
            {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                pixel.blue = UInt8(max(0, min(255, param + Int(pixel.blue))))
                rgbaImage.pixels[index] = pixel
            }
        }
    }
}
