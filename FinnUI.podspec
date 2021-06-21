Pod::Spec.new do |s|
  s.name         = 'FinnUI'
  s.version      = '23.3.0'
  s.summary      = "FINN's iOS UI Features"
  s.author       = 'FINN.no'
  s.homepage     = 'https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system'
  s.social_media_url   = 'https://twitter.com/FINN_tech'
  s.description  = <<-DESC
  FinnUI is the iOS native implementation of some of the UI in the FINN.no app.
                   DESC

  s.license      = 'MIT'
  s.platform      = :ios, '13.0'
  s.swift_version = '5.0'
  s.source        = { :git => "https://github.com/finn-no/finnui-ios.git", :tag => "#{s.version}" }
  s.requires_arc  = true

  s.source_files = 'Sources/*.{h,m,swift}', 'Sources/**/*.{h,m,swift}', 'Sources/**/**/*.{h,m,swift}'
  s.resources    = 'Sources/Assets/Fonts/*.ttf', 'Sources/Assets/*.xcassets', 'Sources/Assets/Sounds/*.{mp3,wav,sf2}'
  s.resource_bundles = {
      'FinnUI' => ['Sources/Assets/*.xcassets', 'Sources/Assets/Fonts/*.ttf', 'Sources/Assets/Sounds/*.{mp3,wav,sf2}']
  }
  s.dependency "FinniversKit"
  s.frameworks = 'Foundation', 'UIKit', 'FinniversKit'
  s.weak_frameworks = 'SwiftUI'
end
