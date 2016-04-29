Pod::Spec.new do |s|
  s.name             = "OKAlertController"
  s.version          = "1.0.3"
  s.summary          = "Customisable UIAlertController controller"
  s.description      = <<-DESC
Customisable UIAlertController controller.
                         DESC

  s.homepage         = "https://github.com/OlehKulykov/OKAlertController"
  s.screenshots     = "https://github.com/OlehKulykov/OKAlertController/raw/master/Resources/ScreenShot1.png"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "OlehKulykov" => "info@resident.name" }
  s.source           = { :git => "https://github.com/OlehKulykov/OKAlertController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'OKAlertController/Controller/OKAlertController/*.{swift}'
  s.requires_arc = true
end
