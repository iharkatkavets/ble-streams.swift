Pod::Spec.new do |s|
  s.name             = 'BLEStreams'
  s.version          = '0.1.0'
  s.summary          = 'Custom \'InputStream\' and \'OutputStream\' implementation'

  s.description      = <<-DESC
Subclasses of InputStream and OutputStream with implemented of required methods. The idea is to look at the development for custom InputStream and OutputStream.
                       DESC

  s.homepage         = 'https://github.com/iharkatkavets/ble-streams.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ihar Katkavets' => 'iharkatkavets@users.noreply.github.com' }
  s.source           = { :git => 'git@github.com:iharkatkavets/ble-streams.swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.7'

  s.source_files = 'BLEStreams/Classes/**/*'
end
