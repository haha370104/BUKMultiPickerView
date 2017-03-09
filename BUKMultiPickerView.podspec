Pod::Spec.new do |s|

  s.name         = "BUKMultiPickerView"
  s.version      = "0.0.1"
  s.summary      = "A simple multi-row picker"
  s.description  = "A simple customizable multi-row picker"
  s.homepage     = "https://github.com/iException/BUKMultiPickerView.git"
  s.license      = "MIT"
  s.author       = { "Xiang Li" => "lixiang@baixing.com" }
  s.source       = { :git => "https://github.com/iException/BUKMultiPickerView.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "Classes/**/*.{h,m}"
  s.frameworks   = 'UIKit', 'Foundation'
  s.requires_arc = true

end
