platform :ios, '9.0'

def commonPods
  use_frameworks!
  pod 'PromiseKit', '~> 6.8'
  pod 'SwiftLint', '~> 0.40.3'
end

target 'App' do
  commonPods

  target 'UnitTests' do
    inherit! :search_paths
  end

  target 'UITests' do
    inherit! :search_paths
  end
end

target 'Core' do
  commonPods
end

target 'Cloud' do
  commonPods
end

target 'Database' do
  commonPods
end

target 'Secure' do
  commonPods
end

target 'Auth' do
  commonPods
end

target 'Features' do
  commonPods
end
