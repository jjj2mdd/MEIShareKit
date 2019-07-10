Pod::Spec.new do |s|
  s.name             = 'MEIShareKit'
  s.version          = '0.1.1'
  s.summary          = 'MEIShareKit是移动中台项目iOS端实现分享功能的基础组件。'

  s.description      = <<-DESC
  目前已实现QQ，微信，微博三个平台的分享，后续会根据需求反馈集成其他平台以及扩展已有平台下新的分享功能。
                       DESC

  s.homepage         = 'http://10.25.81.246/mobile/MEIShareKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'maochaolong041' => 'maochaolong041@pingan.com.cn' }
  s.source           = { :git => 'http://10.25.81.246/mobile/MEIShareKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.subspec 'Core' do |c|
    c.source_files = 'MEIShareKit/Classes/Core/*'
  end

  s.subspec 'UI' do |u|
    u.source_files = 'MEIShareKit/Classes/UI/*'
    u.dependency 'MEIShareKit/Core'
  end

end
