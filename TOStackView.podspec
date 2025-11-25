Pod::Spec.new do |s|
  s.name     = 'TOStackView'
  s.version  = '1.1.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A basic container view that handles laying out a collection of subviews in vertical or horizontal alignments.'
  s.homepage = 'https://github.com/TimOliver/TOStackView'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOStackView.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.platform = :ios, '9.0'
  s.source_files = 'TOStackView/**/*.{h,m}'
end
