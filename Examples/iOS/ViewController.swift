//
//  ViewController.swift
//  Example
//
//  Created by Dawid Płatek on 12/11/2019.
//  Copyright © 2020 Optidash UG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var outputLabel: UILabel!
    @IBOutlet private weak var outputImageView: UIImageView!

    let client = OptidashClient(key: "YOUR-API-KEY")

    // MARK: Actions

    @IBAction private func firstExampleButtonTapped() {
        resetOutputViews()

        let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "jpg")!
        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.upload(fileUrl: fileUrl).border(parameters).toJson() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        self?.outputLabel.text = "Response: \(dictionary!)"
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.text = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.text = "Error: \(error)"
        }
    }

    @IBAction private func secondExampleButtonTapped() {
        resetOutputViews()

        let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "jpg")!
        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.upload(fileUrl: fileUrl).border(parameters).toImageData() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.outputImageView.image = image
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.text = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.text = "Error: \(error)"
        }
    }

    @IBAction private func thirdExampleButtonTapped() {
        resetOutputViews()

        let imageURL = URL(string: "https://images.unsplash.com/photo-1576678052826-04fd6590483f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=562&q=80")!

        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.fetch(url: imageURL.absoluteString).border(parameters).toJson() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        self?.outputLabel.text = "Response: \(dictionary!)"
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.text = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.text = "Error: \(error)"
        }
    }

    @IBAction private func fourthExampleButtonTapped() {
        resetOutputViews()

        let imageURL = URL(string: "https://images.unsplash.com/photo-1576678052826-04fd6590483f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=562&q=80")!

        let parameters: [String : Any] = ["size": 10, "color": "#ff0000", "radius": 5, "background": "#cccccc"]

        do {
            try client.fetch(url: imageURL.absoluteString).border(parameters).toImageData() { [weak self] (result) in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.outputImageView.image = image
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.outputLabel.text = "Error: \(error)"
                    }
                }
            }
        } catch let error {
            outputLabel.text = "Error: \(error)"
        }
    }

    private func resetOutputViews() {
        outputImageView.image = nil
        outputLabel.text = nil
    }
}

