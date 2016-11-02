import Foundation

// MARK: - Pixel extension
public extension Pixel
{
    public var gray : UInt8{
        return UInt8(max(0, min(255, Int(self.red) + Int(self.green) + Int(self.blue) / 3)))
    }
}

// MARK: - RGBAImage extension
public extension RGBAImage
{
    public var totalPixels : Int{
        return self.width * self.height
    }
    
    public var avgRed : Int{
        var totalRed = 0
        for x in 0..<self.width
        {
            for y in 0..<self.height
            {
                let index = y * self.width + x
                let pixel = self.pixels[index]
                totalRed += Int(pixel.red)
            }
        }
        return Int(totalRed) / self.totalPixels
    }
    
    public var avgGreen : Int{
        var totalGreen = 0
        for x in 0..<self.width
        {
            for y in 0..<self.height
            {
                let index = y * self.width + x
                let pixel = self.pixels[index]
                totalGreen += Int(pixel.green)
            }
        }
        return Int(totalGreen) / self.totalPixels
    }
    
    public var avgBlue : Int{
        var totalBlue = 0
        for x in 0..<self.width
        {
            for y in 0..<self.height
            {
                let index = y * self.width + x
                let pixel = self.pixels[index]
                totalBlue += Int(pixel.blue)
            }
        }
        return Int(totalBlue) / self.totalPixels
    }
}
