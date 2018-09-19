source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.4'
use_frameworks!

target 'TheMovieHunter' do
pod 'SwiftyJSON'
pod 'Alamofire'
pod 'AlamofireImage'
pod 'Fabric'
pod 'Crashlytics'
pod 'SwiftRangeSlider'
pod 'PKHUD'
pod 'Hero'
pod 'Dip'
pod 'Dip-UI'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
