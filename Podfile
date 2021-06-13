platform :ios, '11.0'

target 'PlantControlApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PlantControlApp
  pod 'SnapKit', '~> 5.0.0'
  pod 'DifferenceKit'
  pod 'AppCenter' 
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end