# -*- encoding : utf-8 -*-
require "test_helper"
describe MineController do
  before do
    @user=User.nondeleted.normal.where(:email.nin=>Setting.admin_emails).first
  end
  it "游客在课件管理器什么都访问不了" do
    assert @controller.current_user.nil?
    get :index
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :dashboard
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :my_coursewares
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :view_all_playlists
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :my_coursewares_copyright
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
  	get :my_history
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
  	get :my_search_history
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :my_watch_later_coursewares
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :my_favorites
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :my_liked_coursewares
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
    assert @controller.current_user.nil?
    get :my_liked_lists
    assert 302==@response.status,'游客状态：游客【不能】进入课件管理器'
  end
  it '课件管理器之首页index' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :index
    assert (@response.status == 302 and URI(@response.location).path == '/mine/my_coursewares'),'登录的用户可以访问课件管理器首页,'
  end
  it '课件管理器之信息中心dashboard' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :dashboard
    assert @response.success?,'登录的用户可以访问信息中心'
  end
  it '课件管理器之上传的课件my_coursewares' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_coursewares
    assert @response.success?,'登录的用户可以访问上传的课件'
  end
  it '课件管理器之课件锦囊view_all_playlists' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :view_all_playlists
    assert @response.success?,'登录的用户可以访问课件锦囊'
  end
  it '课件管理器之版权声明my_coursewares_copyright' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_coursewares_copyright
    assert @response.success?,'登录的用户可以访问版权声明'
  end
	it '课件管理器之历史记录my_history' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_history
    assert @response.success?,'登录的用户可以访问历史记录'
  end
	it '课件管理器之搜索记录my_search_history' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_search_history
    assert @response.success?,'登录的用户可以访问搜索记录'
  end
  it '课件管理器之稍后阅读my_watch_later_coursewares' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_watch_later_coursewares
    assert @response.success?,'登录的用户可以访问稍后阅读'
  end
  it '课件管理器之收藏过的课件my_favorites' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_favorites
    assert @response.success?,'登录的用户可以访问收藏过的课件'
  end
  it '课件管理器之顶过的课件my_liked_coursewares' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_liked_coursewares
    assert @response.success?,'登录的用户可以访问顶过的课件'
  end
  it '课件管理器之顶过的课件锦囊my_liked_lists' do
    denglu! @user
    assert @controller.current_user.id==@user.id
    get :my_liked_lists
    assert @response.success?,'登录的用户可以访问顶过的课件锦囊'
  end
end
