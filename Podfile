platform :ios, '12.1'
use_frameworks!

def linkProject (name)
  project '#{name}/#{name}.project'
end

workspace 'onekyat'

def share_pods
  pod 'RxSwift', '6.1.0'
  pod 'RxCocoa', '6.1.0'
  pod 'RxSwiftExt'
  pod 'RxKeyboard'
  pod 'RxRealm', '~> 5.0.1'
  pod 'CRRefresh', '1.1.3'
  pod 'DeviceKit', '~> 4.0'
end

def ui_pods
  pod "Device"
  pod 'Kingfisher', '6.3.0'
end

def data_pods
  pod 'KeychainAccess', '4.2.1'
end

target 'onekyat' do
  project 'onekyat/onekyat.project'
  share_pods
  ui_pods
  data_pods
  pod 'IQKeyboardManagerSwift', '6.5.6'
  
end

target 'Data' do
  project 'Data/Data.project'
  share_pods
  data_pods
end

target 'CommonExtensions' do
  project 'CommonExtensions/CommonExtensions.project'
  share_pods
  pod 'Kingfisher', '6.3.0'
end

target 'Utilities' do
  project 'Utilities/Utilities.project'
  share_pods
end

target 'CommonUI' do
  project 'CommonUI/CommonUI.project'
  share_pods
  ui_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
    end
  end
end
