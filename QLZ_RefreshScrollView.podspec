
Pod::Spec.new do |s|
  s.name         = "QLZ_RefreshScrollView"
  s.version      = "0.0.1"
  s.summary      = “iOS下拉刷新”
  # s.description  = <<-DESC
                   DESC
  s.homepage     = "https://github.com/qlz130514988/QLZ_RefreshScrollView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "qlz130514988" => "130514988@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/qlz130514988/QLZ_RefreshScrollView.git”, :tag => “0.0.1” }
  s.source_files  = "QLZ_RefreshScrollView", "QLZ_RefreshScrollView/**/*.{h,m}"
  s.frameworks = “UIKit”, “Foundation”
end
