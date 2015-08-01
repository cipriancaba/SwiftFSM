
Pod::Spec.new do |s|
  s.name             = "SwiftFSM"
  s.version          = "0.2.0"
  s.summary          = "A solid yet simple fsm implementation in Swift"
  s.description      = <<-DESC
                       Finit state machine implementation using Enums, Generics and Closures
                       DESC
  s.homepage         = "https://github.com/cipriancaba/SwiftFSM"
  s.license          = 'MIT'
  s.author           = { "Ciprian Caba" => "cipri@cipriancaba.com" }
  s.source           = { :git => "https://github.com/cipriancaba/SwiftFSM.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cipriancaba'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
