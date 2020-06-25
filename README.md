<p align="center"><a href="https://optidash.ai"><img src="media/logotype.png" alt="Optidash" width="143" height="45"/></a></p>

<p align="center">
Optidash is a modern, AI-powered image optimization and processing API.<br>We will drastically speed-up your websites and save you money on bandwidth and storage.
</p>

---
<p align="center">
<strong>The official Swift integration for Optidash API.</strong><br>
<br>
<img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/v/Optidash?style=flat&color=success"/>
<img src="https://img.shields.io/github/issues-raw/optidash-ai/optidash-swift?style=flat&color=success"/>
</p>

---

### Documentation
See the [Optidash API docs](https://docs.optidash.ai/).


### Installation with Carthage

Carthage is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application. You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Optidash into your Xcode project using Carthage, specify it in your Cartfile:

```bash
github "optidash-ai/optidash-swift"
```

### Installation with CocoaPods

```bash
source 'https://github.com/CocoaPods/Specs.git'
pod 'Optidash', '~> 1.0.0'
```

### Quick examples
Optidash API enables you to provide your images for processing in two ways - by uploading them directly to the API ([Image Upload](https://docs.optidash.ai/requests/image-upload)) or by providing a publicly available image URL ([Image Fetch](https://docs.optidash.ai/requests/image-fetch)).

You may also choose your preferred [response method](https://docs.optidash.ai/introduction#choosing-response-method-and-format) on a per-request basis. By default, the Optidash API will return a [JSON response](https://docs.optidash.ai/responses/json-response-format) with rich metadata pertaining to input and output images. Alternatively, you can use [binary responses](https://docs.optidash.ai/responses/binary-responses). When enabled, the API will respond with a full binary representation of the resulting (output) image. This Swift module exposes two convenience methods for interacting with binary responses: `.toFile()` and `.toBuffer()`.

#### Image upload
Here is a quick example of uploading a local file for processing. It calls `.toJson()` at a final step and instructs the API to return a JSON response.

```swift
// Pass your Optidash API Key to the constructor
let opti = OptidashClient(key: "YOUR-API-KEY")

// Upload an image from disk and resize it to 1024 x 768,
// using 'fit' mode and gravity set to 'bottom'
let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "jpg")!
let parameters: [String : Any] = [
    "width": 1024,
    "height": "768",
    "mode": "fit",
    "gravity": "bottom"
]

do {
    try opti.upload(fileUrl: fileUrl)
            .resize(parameters)
            .toJson() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let response = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        print(response!)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                    }
                }
            }
} catch let error {
    print(error)
}
```

#### Image fetch
If you already have your source visuals publicly available online, we recommend using Image Fetch by default. That way you only have to send a JSON payload containing image URL and processing steps. This method is also much faster than uploading a full binary representation of the image.

```swift
// Pass your Optidash API Key to the constructor
let opti = OptidashClient(key: "YOUR-API-KEY")

// Provide a publicly available image URL with `.fetch()` method
// and resize it to 1024 x 768 using 'fit' mode and gravity set to 'bottom'
let imageURL = URL(string: "https://www.website.com/image.jpg")!
let parameters: [String : Any] = [
    "width": 1024,
    "height": "768",
    "mode": "fit",
    "gravity": "bottom"
]

do {
    try opti.fetch(url: imageURL)
            .resize(parameters)
            .toJson() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let response = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        print(response!)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                    }
                }
            }
} catch let error {
    print(error)
}
```

### License
This software is distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.