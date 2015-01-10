Pod::Spec.new do |s|
  s.name         = "MYSForms"
  s.version      = "0.0.5"
  s.summary      = "Easily build forms on ios 7+."
  s.description  = <<-DESC
                   A longer description of MYSForms in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.homepage     = "https://github.com/mysterioustrousers/MYSForms"
  s.license      = "MIT"
  s.author             = { "Adam Kirk" => "atomkirk@gmail.com" }
  s.social_media_url   = "http://twitter.com/atomkirk"
  s.platform     = :ios, "7.0"
  s.source       =  {
                      :git => "https://github.com/mysterioustrousers/MYSForms.git",
                      :tag => "#{s.version}"
                    }
  s.source_files  = "MYSForms/MYSForms/**/*.{h,m}"
  s.resource_bundles = { 'MYSForms' => "MYSForms/MYSForms/**/*.png" }
  s.resources = "MYSForms/MYSForms/**/*.xib"
  s.requires_arc = true
end
