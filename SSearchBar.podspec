
Pod::Spec.new do |s|

  s.name         = "SSearchBar"
  s.version      = "1.0.1"
  s.summary      = "A short description of SSearchBar."

  s.description  = <<-DESC
  "Simple search bar with timer after typing text for search"
                   DESC
  s.homepage     = "https://github.com/budris/SSearchBar"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Sak, Andrey2" => "a2.sak@itransition.com" }

  s.platform = :ios, '9.0'
  s.requires_arc = true

  s.source       = { :git => "https://github.com/budris/SSearchBar.git", :tag => "#{s.version}" }
  s.source_files = 'SSearchBar/SSearchBar/**/*'

end
