# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Basic
def basic_pods
  pod 'Alamofire',          '~> 4.4'
  pod 'CodableAlamofire'
  # pod 'SwiftyBeaver'
  pod 'RxSwift',            '~> 4.0'
  pod 'RxCocoa',            '~> 4.0'
  pod 'RxSwiftExt',         '~> 3.0'
end

# Testing
def test_pods
  pod 'RxBlocking',         '~> 4.0'
  pod 'RxTest',             '~> 4.0'
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
