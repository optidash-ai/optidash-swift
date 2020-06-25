Pod::Spec.new do |spec|
  spec.name          = "Optidash"
  spec.version       = "1.0.0"
  spec.summary       = "Official Swift SDK for Optidash"
  spec.description   = "Optidash is an AI-powered image optimization and processing API. We will drastically speed-up your websites and save you money on bandwidth and storage."
  spec.homepage      = "https://optidash.ai"
  spec.license       = { :type => 'MIT', :file => 'LICENSE' }
  spec.author        = { "Optidash" => "support@optidash.ai" }
  spec.source        = { :git => "https://github.com/optidash-ai/optidash-swift.git", :tag => "#{spec.version}" }
  spec.source_files   = 'Optidash/Classes/**/*'
  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target  = "10.14"
  spec.frameworks     = 'UIKit', 'Foundation', 'MobileCoreServices'
  spec.swift_version  = '5.0'
end