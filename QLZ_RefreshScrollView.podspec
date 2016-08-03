
Pod::Spec.new do |s|
  s.name         = "QLZ_RefreshScrollView"
  s.version      = "0.0.1"
  s.summary      = "iOS refresh and load more."
  s.homepage     = "https://github.com/qlz130514988/QLZ_RefreshScrollView"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "qlz130514988." => "https://github.com/qlz130514988" }
  s.platform = :ios, "7.0"
  s.source   = { :git => 'https://github.com/qlz130514988/QLZ_RefreshScrollView.git', :tag => s.version, :submodules => true }
  s.source_files  = "QLZ_RefreshScrollView/*.{h,m}", "QLZ_RefreshScrollView/**/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
end
