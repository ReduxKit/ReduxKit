Pod::Spec.new do |s|
  s.name              = 'ReduxKit'
  s.version           = '0.1.4'
  s.summary           = 'A Swift implementation of Redux.'
  s.description       = <<-DESC
                        ReduxKit is a swift implementation of rackt/redux by Dan Abramov and the React Community.
                        A thorough walkthrough and description of the framework can be found at the official Redux repostory: [Redux](http://rackt.github.io/redux)
                        DESC
  s.homepage          = 'http://reduxkit.github.io/ReduxKit/'
  s.documentation_url = 'http://reduxkit.github.io/ReduxKit/api/'
  s.license           = { :type => 'MIT', :file => 'LICENSE' }
  s.authors           = { 'Aleksander Herforth Rendtslev' => 'kontakt@karemedia.dk', 'Karl Bowden' => 'karl@karlbowden.com' }
  s.source            = { :git => 'https://github.com/ReduxKit/ReduxKit.git', :tag => s.version.to_s }
  s.source_files      = 'ReduxKit'
  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
end
