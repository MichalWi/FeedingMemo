# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

target 'Feeding Memo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Feeding Memo
  pod 'CircleMenu'
  pod 'fluid-slider'
  
  swift_4_1_pod_targets = ['CircleMenu', 'fluid-slider']
  
  post_install do | installer |
      installer.pods_project.targets.each do |target|
          if swift_4_1_pod_targets.include?(target.name)
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.1'
              end
          end
      end
  end
end
