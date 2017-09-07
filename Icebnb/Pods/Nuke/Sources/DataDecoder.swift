// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

#if os(watchOS)
    import WatchKit
#endif

/// Decodes image data.
public protocol DataDecoding {
    /// Decodes image data.
    func decode(data: Data, response: URLResponse) -> Image?
}

private let queue = DispatchQueue(label: "com.github.kean.Nuke.DataDecoder")

/// Decodes image data.
public struct DataDecoder: DataDecoding {
    /// Initializes the receiver.
    public init() {}

    /// Creates an image with the given data.
    public func decode(data: Data, response: URLResponse) -> Image? {
        guard DataDecoder.validate(response: response) else { return nil }

        // Image initializers are documented as fully-thread safe:
        //
        // > The immutable nature of image objects also means that they are safe
        //   to create and use from any thread.
        //
        // However, there are some versions of iOS which violated this. The
        // `UIImage` is supposably fully thread safe again starting with iOS 10.
        //
        // The `queue.sync` call below prevents the majority of the potential
        // crashes that could happen on the previous versions of iOS.
        //
        // See also https://github.com/AFNetworking/AFNetworking/issues/2572
        return queue.sync {
            #if os(macOS)
                return NSImage(data: data)
            #else
                #if os(iOS) || os(tvOS)
                    let scale = UIScreen.main.scale
                #else
                    let scale = WKInterfaceDevice.current().screenScale
                #endif
                return UIImage(data: data, scale: scale)
            #endif
        }
    }

    private static func validate(response: URLResponse) -> Bool {
        guard let response = response as? HTTPURLResponse else { return true }
        return (200..<300).contains(response.statusCode)
    }
}

/// Composes multiple data decoders.
public final class DataDecoderComposition: DataDecoding {
    public let decoders: [DataDecoding]

    /// Composes multiple data decoders.
    public init(decoders: [DataDecoding]) {
        self.decoders = decoders
    }

    /// Decoders are applied in order in which they are present in the decoders
    /// array. The decoding stops when one of the decoders produces an image.
    public func decode(data: Data, response: URLResponse) -> Image? {
        for decoder in decoders {
            if let image = decoder.decode(data: data, response: response) {
                return image
            }
        }
        return nil
    }
}
