platform :ios, '9.0'

target 'MatPuls' do
  use_frameworks!

  # Pods for MatPuls

  pod 'RealmSwift'
  pod 'Eureka', '~> 2.0.0-beta.1'
  pod 'GRMustache.swift'
  pod 'iOS-htmltopdf'
  pod 'PKHUD', '~> 4.0'

  target 'MatPulsTests' do
      inherit! :search_paths
  end
  
  target 'MatPulsUITests' do
      inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
