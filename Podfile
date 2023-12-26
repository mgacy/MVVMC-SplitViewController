# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# Ignore all warnings from all pods
inhibit_all_warnings!

# Basic
def basic_pods
  pod 'Alamofire',          '~> 4.4'
  pod 'CodableAlamofire'
  pod 'ColorCompatibility'
  # pod 'SwiftyBeaver'
  pod 'RxSwift',            '~> 5.0'
  pod 'RxCocoa',            '~> 5.0'
  pod 'RxSwiftExt',         '~> 5.0'
  pod 'RxDataSources',      '~> 4.0'
end

# Testing
def test_pods
  pod 'RxBlocking',         '~> 5.0'
  pod 'RxTest',             '~> 5.0'
end

target 'MVVMC-SplitViewController' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVVMC-SplitViewController
  basic_pods

  target 'MVVMC-SplitViewControllerTests' do
    inherit! :search_paths
    # Pods for testing
    # test_pods
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      
      # Fix RxSwift error
      # https://stackoverflow.com/a/75729977/4472195
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end

      # Enable RxSwift.Resources for debugging
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
  end

end
