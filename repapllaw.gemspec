Gem::Specification.new do |s|
  s.name        = 'repapllaw'
  s.version     = '0.0.1'
  s.date        = '2017-06-02'
  s.summary     = 'Automatically change your wallpaper'
  s.description = 'A simple gem which will automatically change your wallpaper'
  s.authors     = ['Tran Xuan Nam']
  s.email       = 'tran.xuan.nam@framgia.com'
  s.files       = ['lib/repapllaw.rb']
  s.executables << 'repapllaw'
  s.homepage    = 'https://rubygems.org/gems/gf_beauty'
  s.license     = 'MIT'

  s.add_dependency 'httparty'
end
