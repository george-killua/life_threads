#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint story_video_encoder.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'story_video_encoder'
  s.version          = '0.1.0'
  s.summary          = 'Encodes Flutter-rendered RGBA frames into an H.264 MP4 with an optional AAC music track (AVFoundation only).'
  s.description      = <<-DESC
Encodes Flutter-rendered RGBA frames into an H.264 MP4 with an optional AAC music track (AVFoundation only).
                       DESC
  s.homepage         = 'https://github.com/george-killua/life_threads'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LifeThreads' => 'george.kassih@icloud.com' }
  s.source           = { :path => '.' }
  s.source_files = 'story_video_encoder/Sources/story_video_encoder/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.9'
  s.frameworks = 'AVFoundation', 'Accelerate', 'CoreVideo', 'CoreMedia'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'story_video_encoder_privacy' => ['story_video_encoder/Sources/story_video_encoder/PrivacyInfo.xcprivacy']}
end
