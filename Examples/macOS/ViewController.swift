//
//  ViewController.swift
//  Example macOS
//
//  Created by Dawid Płatek on 21/06/2020.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet private weak var outputLabel: NSTextField!
    @IBOutlet private weak var outputImageView: NSImageView!

    let client = OptidashClient(key: "YOUR-API-KEY")

    // MARK: Actions

    @IBAction private func firstExampleButtonTapped(_ sender: Any) {
        resetOutputViews()

        let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "jpg")!
        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.upload(fileUrl: fileUrl).border(parameters).toJson() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        self?.outputLabel.stringValue = "Response: \(dictionary!)"
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.stringValue = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.stringValue = "Error: \(error)"
        }
    }

    @IBAction private func secondExampleButtonTapped(_ sender: Any) {
        resetOutputViews()

        let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "jpg")!
        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.upload(fileUrl: fileUrl).border(parameters).toImageData() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = NSImage(data: data)
                        self?.outputImageView.image = image
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.stringValue = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.stringValue = "Error: \(error)"
        }
    }

    @IBAction private func thirdExampleButtonTapped(_ sender: Any) {
        resetOutputViews()

        let imageURL = URL(string: "https://images.unsplash.com/photo-1576678052826-04fd6590483f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=562&q=80")!

        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.fetch(url: imageURL.absoluteString).border(parameters).toJson() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        self?.outputLabel.stringValue = "Response: \(dictionary!)"
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.stringValue = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.stringValue = "Error: \(error)"
        }
    }

    @IBAction private func fourthExampleButtonTapped(_ sender: Any) {
        resetOutputViews()

        let imageURL = URL(string: "https://images.unsplash.com/photo-1576678052826-04fd6590483f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=562&q=80")!

        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.fetch(url: imageURL.absoluteString).border(parameters).toImageData() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = NSImage(data: data)
                        self?.outputImageView.image = image
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.stringValue = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.stringValue = "Error: \(error)"
        }
    }

    private func resetOutputViews() {
        outputImageView.image = nil
        outputLabel.stringValue = ""
    }

}

