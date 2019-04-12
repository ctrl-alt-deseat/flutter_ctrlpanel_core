#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ctrlpanel_core'
  s.version          = '0.2.0'
  s.summary          = 'Core library to build a client that interacts with the Ctrlpanel API.'
  s.description      = <<-DESC
Core library to build a client that interacts with the Ctrlpanel API.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CtrlpanelCore', '1.0.0-alpha.30'

  s.ios.deployment_target = '11.0'
end
