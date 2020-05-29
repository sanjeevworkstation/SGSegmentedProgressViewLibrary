Pod::Spec.new do |spec|

   spec.name          = "SGSegmentedProgressViewLibrary"

  spec.version        = "0.0.2"

  spec.summary        = "a segmented progress view"

  spec.description    = "Library to add a segmented progress view like as Instagram, whatsapp"

  spec.homepage       = "https://github.com/sanjeevworkstation/SGSegmentedProgressViewLibrary"

  spec.license        = { :type => "MIT", :file => "LICENSE" }

  spec.author         = { "Sanjeev Gautam" => "sanjeevworkstation@gmail.com" }

  spec.platform       = :ios, "9.0"
  spec.swift_version  = '4.2'

  spec.source         = { :git => "https://github.com/sanjeevworkstation/SGSegmentedProgressViewLibrary.git", :tag => '0.0.2' }

  #spec.source_files   = "SGSegmentedProgressViewLibrary/SGSegmentedProgressViewLibrary/**/*.{swift}"

  spec.vendored_frameworks = 'SGSegmentedProgressViewLibrary/SGSegmentedProgressViewLibrary/SGSegmentedProgressView.framework'

end