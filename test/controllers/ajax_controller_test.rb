# -*- encoding : utf-8 -*-
require "test_helper"
describe AjaxController do
  before do
    @user=User.nondeleted.normal.where(:email.nin=>Setting.admin_emails).first
  end

  it '有没有新通知all_unread_notification_num - 游客状态' do    
    assert @controller.current_user.nil?
      get 'all_unread_notification_num'
    assert 401==@response.status,'没登陆的用户没啥通知可获取的，401禁止使用此操作'
  end
  it '有没有新通知all_unread_notification_num' do    
    denglu! @user
    assert @controller.current_user.id==@user.id
      get 'all_unread_notification_num'
    assert @response.success?,'登录了的用户可以获得现在有没有新通知'
  end
 

  it "目前的注册程度current_user_reg_extent - 游客状态" do
    assert @controller.current_user.nil?
      get 'current_user_reg_extent'
    assert 401==@response.status,'游客不可以取得它的目前的注册程度，用于第一次注册时的进度条'
  end
  it "目前的注册程度current_user_reg_extent" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      get 'current_user_reg_extent'
    assert @response.success?,'登录用户可以取得它的目前的注册程度，用于第一次注册时的进度条'
  end

  it "稍后阅读watch_later - 游客状态" do
    assert @controller.current_user.nil?
      get 'watch_later',{"courseware_id"=>"50a72631e13823576200005f"}
    assert 401==@response.status,'游客不能稍后阅读'
  end
  it "稍后阅读watch_later" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      get 'watch_later',{"courseware_id"=>@cw.id.to_s}
    assert @response.success?,'登录用户可以稍后阅读'
  end


  it "上传过程中得到动态转码状态presentations_status - 游客状态" do
    assert @controller.current_user.nil?
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      get 'presentations_status',{"id"=>@cw.id.to_s}
    assert 401==@response.status,'游客不能presentations_status'
  end
  it "上传过程中得到动态转码状态presentations_status" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      get 'presentations_status',{"id"=>@cw.id.to_s}
    assert @response.success?,'登录用户可以presentations_status'
  end
    

  it "注册真实姓名检测checkUsername - 游客状态" do
    assert @controller.current_user.nil?
      get 'checkUsername',{"q"=>"是对方即可"}
    assert @response.success?,'游客可以'
  end
  it "注册真实姓名检测checkUsername" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      get 'checkUsername',{"q"=>"是对方即可"}
    assert @response.success?,'登录用户可以checkUsername'
  end
    

  it "注册Email检测checkEmailAjax - 游客状态" do
    assert @controller.current_user.nil?
      get 'checkEmailAjax',{"q"=>"pmq2001@gmail.com"}
    assert @response.success?,'游客可以'
  end
  it "注册Email检测checkEmailAjax" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      get 'checkEmailAjax',{"q"=>"pmq2001@gmail.com"}
    assert @response.success?,'登录用户可以checkEmailAjax'
  end
    
    
  it "登录用户存在性检测logincheck - 游客状态" do
    assert @controller.current_user.nil?
      post 'logincheck',{"userEmail"=>"pmq2001@gmail.com"}
    assert @response.success?,'游客可以logincheck'
  end
  it "登录用户存在性检测logincheck" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'logincheck',{"userEmail"=>"pmq2001@gmail.com"}
    assert @response.success?,'登录用户可以logincheck'
  end
    

  it "上传课件页面老师列表动态重载get_teachers - 游客状态" do
    assert @controller.current_user.nil?
      get 'get_teachers',{"psvr_f"=>Course.nondeleted.gotfid.first.fid.to_s}
    assert 401==@response.status,'游客不能get_teachers'
  end
  it "上传课件页面老师列表动态重载get_teachers" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      get 'get_teachers',{"psvr_f"=>Course.nondeleted.gotfid.first.fid.to_s}
    assert @response.success?,'登录用户可以get_teachers'
  end
    

  it "选择课程对话框课程动态重载get_forum - 游客状态" do
    assert @controller.current_user.nil?
      post 'get_forum',{"fup"=>Department.nondeleted.gotfid.first.fid.to_s}
    assert @response.success?,'游客可以get_forum'
  end
  it "选择课程对话框课程动态重载get_forum" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'get_forum',{"fup"=>Department.nondeleted.gotfid.first.fid.to_s}
    assert @response.success?,'登录用户可以get_forum'
  end
    

  it "选择锦囊列表的排序方式playlist_sort - 游客状态" do
    assert @controller.current_user.nil?
      post 'playlist_sort',{"sort"=>"privacy"}
    assert 401==@response.status,'游客不能playlist_sort'
  end
  it "选择锦囊列表的排序方式playlist_sort" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'playlist_sort',{"sort"=>"privacy"}
    assert @response.success?,'登录用户可以playlist_sort'
  end
    

  it "动态建立新的锦囊create_new_playlist - 游客状态" do
    assert @controller.current_user.nil?
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'create_new_playlist',{"list_title"=>"dfsdsfdsfdfsdsfdsfdsfdsf", "is_private"=>"public", "cwid"=>@cw.id.to_s}
    assert 401==@response.status,'游客不能create_new_playlist'
  end
  it "动态建立新的锦囊create_new_playlist" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'create_new_playlist',{"list_title"=>"dfsdsfdsfdfsdsfdsfdsfdsf", "is_private"=>"public", "cwid"=>@cw.id.to_s}
    assert @response.success?,'登录用户可以create_new_playlist'
  end
    

  it "动态读取分享面板get_share_panel - 游客状态" do
    assert @controller.current_user.nil?
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_share_panel',{"cw_id"=>@cw.id.to_s}
    assert @response.success?,'游客可以get_share_panel'
  end
  it "动态读取分享面板get_share_panel" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_share_panel',{"cw_id"=>@cw.id.to_s}
    assert @response.success?,'登录用户可以get_share_panel'
  end
    

  it "动态读取部分分享面板get_share_partial - 游客状态" do
    assert @controller.current_user.nil?
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_share_partial',{'type'=>'embed','cw_id'=>@cw.id.to_s}
    assert @response.success?,'游客可以get_share_partial'
  end
  it "动态读取部分分享面板get_share_partial" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_share_partial',{'type'=>'embed','cw_id'=>@cw.id.to_s}
    assert @response.success?,'登录用户可以get_share_partial'
  end
    
  it "得到更多课件操作get_cw_operation - 游客状态" do
    assert @controller.current_user.nil?
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_cw_operation',{"type"=>"addto", "cw_id"=>@cw.id.to_s}
    assert  401==@response.status,'游客不可以get_cw_operation'
  end
  it "得到更多课件操作get_cw_operation" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_cw_operation',{"type"=>"addto", "cw_id"=>@cw.id.to_s}
    assert @response.success?,'登录用户可以get_cw_operation'
  end

  it "邮件分享课件ajax_send_email - 游客状态" do
    assert @controller.current_user.nil?
      post 'ajax_send_email'
    assert 401 == @response.status,'游客可以ajax_send_email'
  end
  it "邮件分享课件ajax_send_email" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'ajax_send_email'
    assert @response.success?,'登录用户可以ajax_send_email'
  end
    

  it "举报课件flag_cw - 游客状态" do
    assert @controller.current_user.nil?
      post 'flag_cw',{"cw_id"=>"5068717de13823350b001378", "reason"=>"10", "form"=>{"0"=>{"name"=>"utf8", "value"=>"✓"}, "1"=>{"name"=>"authenticity_token", "value"=>"xa+sJmZviaS68wbTNGrCxLqwl264DWHfBSE6w07gczI="}, "2"=>{"name"=>"flag_page", "value"=>"1"}, "3"=>{"name"=>"flag_protected_group", "value"=>"disability"}, "4"=>{"name"=>"flag_desc", "value"=>"dfasadfsdsafdasf"}}}
    assert 401==@response.status,'游客不能flag_cw'
  end
  it "举报课件flag_cw" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'flag_cw',{"cw_id"=>@cw.id.to_s, "reason"=>"10", "form"=>{"0"=>{"name"=>"utf8", "value"=>"✓"}, "1"=>{"name"=>"authenticity_token", "value"=>"xa+sJmZviaS68wbTNGrCxLqwl264DWHfBSE6w07gczI="}, "2"=>{"name"=>"flag_page", "value"=>"1"}, "3"=>{"name"=>"flag_protected_group", "value"=>"disability"}, "4"=>{"name"=>"flag_desc", "value"=>"dfasadfsdsafdasf"}}}
    assert @response.success?,'登录用户可以flag_cw'
  end
    

  it "动态顶踩回调get_dynamic_dingcai - 游客状态" do
    assert @controller.current_user.nil?
      post 'get_dynamic_dingcai',{"cw_id"=>"5068717de13823350b001378"}
    assert 401==@response.status,'游客不能get_dynamic_dingcai'
  end
  it "动态顶踩回调get_dynamic_dingcai" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'get_dynamic_dingcai',{"cw_id"=>@cw.id.to_s}
    assert @response.success?,'登录用户可以get_dynamic_dingcai'
  end
    

  it "动态回复已有回复comment_action - 游客状态" do
    assert @controller.current_user.nil?
    @comment = Comment.nondeleted.first
      post 'comment_action',{"cid"=>@comment.id.to_s, "atype"=>"reply"}
    assert 401==@response.status,'游客不能comment_action'
  end
  it "动态回复已有回复comment_action" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @comment = Comment.nondeleted.first
      post 'comment_action',{"cid"=>@comment.id.to_s, "atype"=>"reply"}
    assert @response.success?,'登录用户可以comment_action'
  end
    

  it "排序锦囊get_sorted_playlist - 游客状态" do
    assert @controller.current_user.nil?
      post 'get_sorted_playlist',{"sort"=>"vm-sort-newest"}
    assert 401==@response.status,'游客不能get_sorted_playlist'
  end
  it "排序锦囊get_sorted_playlist" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'get_sorted_playlist',{"sort"=>"vm-sort-newest"}
    assert @response.success?,'登录用户可以get_sorted_playlist'
  end
  
  it "用url的方式把课件放入锦囊add_to_playlist_by_url - 游客状态" do
    assert @controller.current_user.nil?
      post 'add_to_playlist_by_url',{"url"=>"http://ibeike-staging.kejian.tv/coursewares/50a0fbfce138231e3500000e", "playlist_id"=>"50ac5804e13823a446000016"}
    assert 401==@response.status,'游客不能add_to_playlist_by_url'
  end
  it "用url的方式把课件放入锦囊add_to_playlist_by_url" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
    @pl=PlayList.where(:user_id=>@user.id).first
    @pl2=PlayList.where(:user_id.ne=>@user.id).first
      post 'add_to_playlist_by_url',{"url"=>"http://ibeike-staging.kejian.tv/coursewares/#{@cw.id}", "playlist_id"=>@pl.id.to_s}
    assert @response.success?,'登录用户可以add_to_playlist，前提是必须是自己的Play list'
      post 'add_to_playlist_by_url',{"url"=>"http://ibeike-staging.kejian.tv/coursewares/#{@cw.id}", "playlist_id"=>@pl2.id.to_s}
    assert 401==@response.status,'登录用户不可以add_to_playlist，如果不是自己的Play list'
  end
    

  it "点击图标加入稍后阅读add_to_read_later - 游客状态" do
    assert @controller.current_user.nil?
      post 'add_to_read_later',{"cwid"=>"5068f6f0e138237a2c000278", "type"=>"addto"}
    assert 401==@response.status,'游客不能add_to_read_later'
  end
  it "点击图标加入稍后阅读add_to_read_later" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father[0]
      post 'add_to_read_later',{"cwid"=>@cw.id.to_s, "type"=>"addto"}
    assert @response.success?,'登录用户可以add_to_read_later'
  end
    

  it "获得锦囊分享面板get_playlist_share - 游客状态" do
    assert @controller.current_user.nil?
    @pl=PlayList.where(:user_id=>@user.id).first
      post 'get_playlist_share',{"playlist_id"=>"#{@pl.id}", "title"=>"大学物理"}
    assert @response.success?,'游客可以get_playlist_share'
  end
  it "获得锦囊分享面板get_playlist_share" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @pl=PlayList.where(:user_id=>@user.id).first
      post 'get_playlist_share',{"playlist_id"=>"#{@pl.id}", "title"=>"大学物理"}
    assert @response.success?,'登录用户可以get_playlist_share'
  end
    

  it "锦囊投票like_playlist - 游客状态" do
    assert @controller.current_user.nil?
      post 'like_playlist',{"pid"=>"506f043ee138236dfd0003d5", "type"=>"like"}
    assert 401==@response.status,'游客不能like_playlist'
  end
  it "锦囊投票like_playlist" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @pl=PlayList.where(:user_id=>@user.id).first
    @pl2=PlayList.where(:user_id.ne=>@user.id).first
      post 'like_playlist',{"pid"=>@pl.id.to_s, "type"=>"like"}
    assert 401==@response.status,'登录用户可以like_playlist，前提是不能给自己的投'
      post 'like_playlist',{"pid"=>@pl2.id.to_s, "type"=>"like"}
    assert @response.success?,'登录用户可以like_playlist，前提是不能给自己的投'
  end
    

  it "获取课件添加到菜单get_addto_menu - 游客状态" do
    assert @controller.current_user.nil?
      post 'get_addto_menu'
    assert 401==@response.status,'游客不能get_addto_menu'
  end
  it "获取课件添加到菜单get_addto_menu" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'get_addto_menu'
    assert @response.success?,'登录用户可以get_addto_menu'
  end
    

  it "批量添加到锦囊add_to_read_later_array - 游客状态" do
    assert @controller.current_user.nil?
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'add_to_read_later_array',{"cwid"=>[@cw1.id.to_s,@cw2.id.to_s], "type"=>"addto"}
    assert 401==@response.status,'游客不能add_to_read_later_array'
  end
  it "批量添加到锦囊add_to_read_later_array" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'add_to_read_later_array',{"cwid"=>[@cw1.id.to_s,@cw2.id.to_s], "type"=>"addto"}
    assert @response.success?,'登录用户可以add_to_read_later_array'
  end
    
  it "用id的方式把课件放入锦囊add_to_playlist_by_id - 游客状态" do
    assert @controller.current_user.nil?
      post 'add_to_playlist_by_id',{"cwid"=>"50a0fbfce138232535000009", "pid"=>"509631e7e13823741b000745", "on_top"=>"false"}
    assert 401==@response.status,'游客不能add_to_playlist_by_id'
  end
  it "用id的方式把课件放入锦囊add_to_playlist_by_id" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
    @pl=PlayList.where(:user_id=>@user.id).first
    @pl2=PlayList.where(:user_id.ne=>@user.id).first
      post 'add_to_playlist_by_id',{"cwid"=>@cw.id.to_s, "pid"=>@pl.id.to_s, "on_top"=>"false"}
    assert @response.success?,'登录用户可以add_to_playlist，前提是必须是自己的Play list'
      post 'add_to_playlist_by_id',{"cwid"=>@cw.id.to_s, "pid"=>@pl2.id.to_s, "on_top"=>"false"}
    assert 401==@response.status,'登录用户不可以add_to_playlist，如果不是自己的Play list'
  end
    

  it "创建播放列表的同时加入课件create_and_add_to_by_id - 游客状态" do
    assert @controller.current_user.nil?
      post 'create_and_add_to_by_id',{"title"=>"fdsafsadfadsdfasdsaf", "is_private"=>"0", "cwid"=>[]}
    assert 401==@response.status,'游客不能create_and_add_to_by_id'
  end
  it "创建播放列表的同时加入课件create_and_add_to_by_id" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'create_and_add_to_by_id',{"title"=>"fdsafsadfadsdfasdsaf", "is_private"=>"0", "cwid"=>[@cw1.id.to_s,@cw2.id.to_s]}
    assert @response.success?,'登录用户可以create_and_add_to_by_id'
  end
    

  it "为一个课件添加备注save_note_for_one_cw - 游客状态" do
    assert @controller.current_user.nil?
      post 'save_note_for_one_cw',{"title"=>"dfsdsfdsfdfsdsfdsfdsfdsf", "cwid"=>["50a72631e13823576200005f"], "note"=>"dfdfasfdafdasdfsafdasfdsafdadfsadfasdfsadfsafdasdsafdas"}
    assert 401==@response.status,'游客不能save_note_for_one_cw'
  end
  it "为一个课件添加备注save_note_for_one_cw" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'save_note_for_one_cw',{"title"=>"dfsdsfdsfdfsdsfdsfdsfdsf", "cwid"=>[@cw1.id.to_s,@cw2.id.to_s], "note"=>"dfdfasfdafdasdfsafdasfdsafdadfsadfasdfsadfsafdasdsafdas"}
    assert @response.success?,'登录用户可以save_note_for_one_cw'
  end
    

  it "批量添加到收藏add_to_favorites_array - 游客状态" do
    assert @controller.current_user.nil?
      post 'add_to_favorites_array'
    assert 401==@response.status,'游客不能add_to_favorites_array'
  end
  it "批量添加到收藏add_to_favorites_array" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'add_to_favorites_array'
    assert @response.success?,'登录用户可以add_to_favorites_array'
  end
    

  it "批量删除顶过的课件remove_ding_array - 游客状态" do
    assert @controller.current_user.nil?
      post 'remove_ding_array',{"cwid"=>["5068f6abe138237a2c000089", "5068f6dde138237a2c0001e2", "506870b8e13823350b000e29"], "type"=>"remove"}
    assert 401==@response.status,'游客不能remove_ding_array'
  end
  it "批量删除顶过的课件remove_ding_array" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'remove_ding_array',{"cwid"=>[@cw1.id.to_s, @cw2.id.to_s], "type"=>"remove"}
    assert @response.success?,'登录用户可以remove_ding_array'
  end
    

  it "保存阅读点save_page_to_history - 游客状态" do
    assert @controller.current_user.nil?
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'save_page_to_history',{"cwid"=>@cw.id.to_s, "page"=>"0"}
    assert 401==@response.status,'游客不能save_page_to_history'
  end
  it "保存阅读点save_page_to_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
      post 'save_page_to_history',{"cwid"=>@cw.id.to_s, "page"=>"0"}
    assert @response.success?,'登录用户可以save_page_to_history'
  end
    

  it "暂停保存历史记录pause_history - 游客状态" do
    assert @controller.current_user.nil?
      post 'pause_history',{"switch"=>"off"}
    assert 401==@response.status,'游客不能pause_history'
  end
  it "暂停保存历史记录pause_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'pause_history',{"switch"=>"off"}
    assert @response.success?,'登录用户可以pause_history'
  end
    

  it "删除某些历史remove_one_history - 游客状态" do
    assert @controller.current_user.nil?
      post 'remove_one_history',{"cwid"=>["506870c3e13823350b000eaf", "50687033e13823350b00097a"], "type"=>"remove", "time"=>["1352561799", "1352727008"]}
    assert 401==@response.status,'游客不能remove_one_history'
  end
  it "删除某些历史remove_one_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'remove_one_history',{"cwid"=>[@cw1.id.to_s,@cw2.id.to_s], "type"=>"remove", "time"=>["1352561799", "1352727008"]}
    assert @response.success?,'登录用户可以remove_one_history'
  end
    

  it "删除所有历史clear_history - 游客状态" do
    assert @controller.current_user.nil?
      post 'clear_history'
    assert 401==@response.status,'游客不能clear_history'
  end
  it "删除所有历史clear_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'clear_history'
    assert @response.success?,'登录用户可以clear_history'
  end
    

  it "删除某些搜索历史remove_one_search_history - 游客状态" do
    assert @controller.current_user.nil?
      post 'remove_one_search_history',{"cwid"=>["50a1ee6ae13823f92d000006", "50a20803e138239638000037", "50a207a3e138239638000036", "50a2079fe138239638000035", "50a20795e138239638000034", "50a206d6e13823963800002a", "50a20792e138239638000033", "50a2078ee138239638000032", "50a2072ce138239638000031", "50a20728e138239638000030", "50a20721e13823963800002f", "50a2071ae13823963800002e", "50a20714e13823963800002d", "50a206d0e138239638000029", "50a206fbe13823963800002c"], "type"=>"remove"}
    assert 401==@response.status,'游客不能remove_one_search_history'
  end
  it "删除某些搜索历史remove_one_search_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    ss=SearchHistory.new
    ss.user_id = @user.id
    ss.save(:validate=>false)
      post 'remove_one_search_history',{"cwid"=>[ss.id.to_s], "type"=>"remove"}
    assert @response.success?,'登录用户可以remove_one_search_history，前提是自己的搜索记录'
    ss.user_id = User.nondeleted.normal.where(:email.nin=>Setting.admin_emails,:id.ne=>@user.id).first.id
    ss.save(:validate=>false)
      post 'remove_one_search_history',{"cwid"=>[ss.id.to_s], "type"=>"remove"}
    assert 401==@response.status,'登录用户可以remove_one_search_history，前提是自己的搜索记录'
  end
    

  it "暂停记录搜索历史pause_search_history - 游客状态" do
    assert @controller.current_user.nil?
      post 'pause_search_history',{"switch"=>"off"}
    assert 401==@response.status,'游客不能pause_search_history'
  end
  it "暂停记录搜索历史pause_search_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'pause_search_history',{"switch"=>"off"}
    assert @response.success?,'登录用户可以pause_search_history'
  end
    

  it "删除所有搜索历史clear_search_history - 游客状态" do
    assert @controller.current_user.nil?
      post 'clear_search_history'
    assert 401==@response.status,'游客不能clear_search_history'
  end
  it "删除所有搜索历史clear_search_history" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'clear_search_history'
    assert @response.success?,'登录用户可以clear_search_history'
  end
    

  it "删除自己上传的课件delete_upload - 游客状态" do
    assert @controller.current_user.nil?
      post 'delete_upload',{"cwid"=>["50ac639de13823a44600003a"]}
    assert 401==@response.status,'游客不能delete_upload'
  end
  it "删除自己上传的课件delete_upload" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.new
    @cw.uploader_id = @user.id
    @cw.save(:validate=>false)
      post 'delete_upload',{"cwid"=>[@cw.id.to_s]}
    assert @response.success?,'登录用户可以delete_upload，前提是必须自己上传的课件'
    @cw.uploader_id = User.nondeleted.normal.where(:email.nin=>Setting.admin_emails,:id.ne=>@user.id).first.id
    @cw.save(:validate=>false)
      post 'delete_upload',{"cwid"=>[@cw.id.to_s]}
    assert 401==@response.status,'登录用户可以delete_upload，前提是必须自己上传的课件'
  end
    

  it "批量更新课件许可setting_cw_license - 游客状态" do
    assert @controller.current_user.nil?
      post 'setting_cw_license',{"cwid"=>["50ac639de13823a44600003a", "50a72631e13823576200005f"], "type"=>"cc"}
    assert 401==@response.status,'游客不能setting_cw_license'
  end
  it "批量更新课件许可setting_cw_license" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'setting_cw_license',{"cwid"=>[@cw1.id.to_s, @cw2.id.to_s], "type"=>"cc"}
    assert @response.success?,'登录用户可以setting_cw_license'
  end
    

  it "切换到大图列表enable_beauty_view - 游客状态" do
    assert @controller.current_user.nil?
      post 'enable_beauty_view',{"tf"=>"true"}
    assert 401==@response.status,'游客不能enable_beauty_view'
  end
  it "切换到大图列表enable_beauty_view" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'enable_beauty_view',{"tf"=>"true"}
    assert @response.success?,'登录用户可以enable_beauty_view'
  end
    

  it "设置课件公开度set_privacy - 游客状态" do
    assert @controller.current_user.nil?
      post 'set_privacy',{"cwid"=>["50ac639de13823a44600003a", "50a72631e13823576200005f"], "type"=>"unlisted"}
    assert 401==@response.status,'游客不能set_privacy'
  end
  it "设置课件公开度set_privacy" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw1=Courseware.non_redirect.nondeleted.normal.is_father[0]
    @cw2=Courseware.non_redirect.nondeleted.normal.is_father[1]
      post 'set_privacy',{"cwid"=>[@cw1.id.to_s, @cw2.id.to_s], "type"=>"unlisted"}
    assert @response.success?,'登录用户可以set_privacy'
  end
    

  it "更新信息中心的排列方式update_widget_sort - 游客状态" do
    assert @controller.current_user.nil?
      post 'update_widget_sort',{"left"=>["1"], "right"=>["2", "0", "3"]}
    assert 401==@response.status,'游客不能update_widget_sort'
  end
  it "更新信息中心的排列方式update_widget_sort" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'update_widget_sort',{"left"=>["1"], "right"=>["2", "0", "3"]}
    assert @response.success?,'登录用户可以update_widget_sort'
  end
    

  it "请求新的小部件request_widget - 游客状态" do
    assert @controller.current_user.nil?
      post 'request_widget',{"widget_type"=>"video"}
    assert 401==@response.status,'游客不能request_widget'
  end
  it "请求新的小部件request_widget" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'request_widget',{"widget_type"=>"video"}
    assert @response.success?,'登录用户可以request_widget'
  end
    

  it "更新小部件的设置update_widget_property - 游客状态" do
    assert @controller.current_user.nil?
      post 'update_widget_property',{"title"=>"", "num"=>"15", "wid"=>"comments"}
    assert 401==@response.status,'游客不能update_widget_property'
  end
  it "更新小部件的设置update_widget_property" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'update_widget_property',{"title"=>"", "num"=>"15", "wid"=>"comments"}
    assert @response.success?,'登录用户可以update_widget_property'
  end
    

  it "在锦囊播放器里改变列表顺序bar_update_content_in_playlist - 游客状态" do
    assert @controller.current_user.nil?
      post 'bar_update_content_in_playlist',{"content_string"=>["50a72631e13823576200005f", "50a0fbfce138231e3500000e", "50a1035de138231e35000019", "5068717de13823350b001378"], "pid"=>"50ac6fd1e13823a446000046"}
    assert 401==@response.status,'游客不能bar_update_content_in_playlist'
  end
  it "在锦囊播放器里改变列表顺序bar_update_content_in_playlist" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
    @play_list.ua(:user_id,@user.id)
      post 'bar_update_content_in_playlist',{"content_string"=>@play_list.content.collect(&:to_s).shuffle, "pid"=>@play_list.id.to_s}
    assert @response.success?,'登录用户可以bar_update_content_in_playlist，前提是这个播放列表是自己的'
    @play_list.ua(:user_id,User.nondeleted.normal.where(:email.nin=>Setting.admin_emails,:id.ne=>@user.id).first.id)
      post 'bar_update_content_in_playlist',{"content_string"=>@play_list.content.collect(&:to_s).shuffle, "pid"=>@play_list.id.to_s}
    assert @response.body["saveas"]=="saveas",'登录用户可以bar_update_content_in_playlist，如果这个播放列表不是自己的，需要另存为'
  end
    

  it "在锦囊播放器里另存为（表单）bar_request_save_as - 游客状态" do
    assert @controller.current_user.nil?
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_request_save_as',{"playlist_id"=>@play_list.id.to_s}
    assert 401==@response.status,'游客不能bar_request_save_as'
  end
  it "在锦囊播放器里另存为（表单）bar_request_save_as" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_request_save_as',{"playlist_id"=>@play_list.id.to_s}
    assert @response.success?,'登录用户可以bar_request_save_as'
  end
    

  it "在锦囊播放器里另存为bar_playlist_save_as - 游客状态" do
    assert @controller.current_user.nil?
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_playlist_save_as',{"playlist_id"=>@play_list.id.to_s, "title"=>"232222", "description"=>"22222222"}
    assert 401==@response.status,'游客不能bar_playlist_save_as'
  end
  it "在锦囊播放器里另存为bar_playlist_save_as" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_playlist_save_as',{"playlist_id"=>@play_list.id.to_s, "title"=>"232222", "description"=>"22222222"}
    assert @response.success?,'登录用户可以bar_playlist_save_as'
  end
    

  it "在锦囊播放器里重读锦囊信息bar_request_update_bar - 游客状态" do
    assert @controller.current_user.nil?
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_request_update_bar',{"playlist_id"=>@play_list.id.to_s}
    assert 401==@response.status,'游客不能bar_request_update_bar'
  end
  it "在锦囊播放器里重读锦囊信息bar_request_update_bar" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_request_update_bar',{"playlist_id"=>@play_list.id.to_s}
    assert @response.success?,'登录用户可以bar_request_update_bar'
  end
    

  it "在锦囊播放器里删除物体bar_delete_one_content - 游客状态" do
    assert @controller.current_user.nil?
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_delete_one_content',{"pid"=>@play_list.id.to_s, "kid"=>@play_list.content.first.to_s}
    assert 401==@response.status,'游客不能bar_delete_one_content'
  end
  it "在锦囊播放器里删除物体bar_delete_one_content" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
    @play_list.ua(:user_id,@user.id)
      post 'bar_delete_one_content',{"pid"=>@play_list.id.to_s, "kid"=>@play_list.content.first.to_s}
    assert @response.success?,'登录用户可以bar_delete_one_content，前提是锦囊必须是自己的'
    @play_list.ua(:user_id,User.nondeleted.normal.where(:email.nin=>Setting.admin_emails,:id.ne=>@user.id).first.id)
      post 'bar_delete_one_content',{"pid"=>@play_list.id.to_s, "kid"=>@play_list.content.first.to_s}
    assert @response.body["saveas"]=="saveas",'登录用户可以bar_delete_one_content，如果是锦囊不是自己的，另存为'
  end
    

  it "在锦囊播放器里撤销删除物体bar_undo_delete - 游客状态" do
    assert @controller.current_user.nil?
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_undo_delete',{"pid"=>@play_list.id.to_s}
    assert 401==@response.status,'游客不能bar_undo_delete'
  end
  it "在锦囊播放器里撤销删除物体bar_undo_delete" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
    @play_list.ua(:user_id,@user.id)
      post 'bar_undo_delete',{"pid"=>@play_list.id.to_s}
    assert @response.success?,'登录用户可以bar_undo_delete，前提是锦囊必须是自己的'
    @play_list.ua(:user_id,User.nondeleted.normal.where(:email.nin=>Setting.admin_emails,:id.ne=>@user.id).first.id)
      post 'bar_undo_delete',{"pid"=>@play_list.id.to_s}
    assert @response.body["saveas"]=="saveas",'登录用户可以bar_undo_delete，如果不是自己的，返回saveas'
  end
    

  it "在锦囊播放器里加载其他锦囊bar_request_playlists - 游客状态" do
    assert @controller.current_user.nil?
      post 'bar_request_playlists',{ "playlist_id"=>"509631e7e13823741b000746"}
    assert 401==@response.status,'游客不能bar_request_playlists'
  end
  it "在锦囊播放器里加载其他锦囊bar_request_playlists" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'bar_request_playlists',{ "playlist_id"=>@play_list.id.to_s}
    assert @response.success?,'登录用户可以bar_request_playlists'
  end
    

  it "召唤锦囊播放器summonQL - 游客状态" do
    assert @controller.current_user.nil?
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'summonQL',{"playlist_id"=>@play_list.id.to_s, "bar_max"=>"1"}
    assert @response.success?,'游客可以summonQL'
  end
  it "召唤锦囊播放器summonQL" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @play_list=PlayList.no_privacy.destroyable.normal.first
      post 'summonQL',{"playlist_id"=>@play_list.id.to_s, "bar_max"=>"0"}
    assert @response.success?,'登录用户可以summonQL'
  end
    

  it "异步准备上传prepare_upload - 游客状态" do
    assert @controller.current_user.nil?
      post 'prepare_upload',{"count"=>"5"}
    assert 401==@response.status,'游客不能prepare_upload'
  end
  it "异步准备上传prepare_upload" do
    denglu! @user
    assert @controller.current_user.id==@user.id
      post 'prepare_upload',{"count"=>"5"}
    assert @response.success?,'登录用户可以prepare_upload'
  end
    

  it "上传时动态自动保存upload_page_auto_save - 游客状态" do
    assert @controller.current_user.nil?
      post 'upload_page_auto_save',{"presentation"=>{"id"=>"50a72631e13823576200005f", "uptime"=>"", "pdf_filename"=>"某次Kejian.tv会议.pdf", "upload_persentage"=>"100", "title"=>"某次Kejian.tv会议2", "topic"=>" 体育部: 大学生心理素质教育 ", "description"=>"", "keywords"=>"", "teacher"=>"", "other_teacher"=>"", "sort1"=>"lecture_notes", "privacy"=>"public", "reuse"=>"all_rights_reserved", "monetization_style"=>"ads", "enable_overlay_ads"=>"yes", "trueview_instream"=>"on", "allow_syndication"=>"yes", "allow_comments"=>"yes", "allow_comments_detail"=>"all", "allow_comment_ratings"=>"yes", "allow_responses"=>"on", "allow_responses_detail"=>"approval", "allow_embedding"=>"on", "creator_share_feeds"=>"on", "version_date"=>"2012年11月17日", "auto_save"=>"manual"}, "psvr_g"=>Department.nondeleted.gotfid.first.fid.to_s, "psvr_f"=>Course.nondeleted.gotfid.first.fid.to_s}
    assert 401==@response.status,'游客不能upload_page_auto_save'
  end
  it "上传时动态自动保存upload_page_auto_save" do
    denglu! @user
    assert @controller.current_user.id==@user.id
    @cw=Courseware.non_redirect.nondeleted.normal.is_father.first
    @cw.update_attribute(:uploader_id,@user.id)
      post 'upload_page_auto_save',{"presentation"=>{"id"=>@cw.id.to_s, "uptime"=>"", "pdf_filename"=>"某次Kejian.tv会议.pdf", "upload_persentage"=>"100", "title"=>"某次Kejian.tv会议2", "topic"=>" 体育部: 大学生心理素质教育 ", "description"=>"", "keywords"=>"", "teacher"=>"", "other_teacher"=>"", "sort1"=>"lecture_notes", "privacy"=>"public", "reuse"=>"all_rights_reserved", "monetization_style"=>"ads", "enable_overlay_ads"=>"yes", "trueview_instream"=>"on", "allow_syndication"=>"yes", "allow_comments"=>"yes", "allow_comments_detail"=>"all", "allow_comment_ratings"=>"yes", "allow_responses"=>"on", "allow_responses_detail"=>"approval", "allow_embedding"=>"on", "creator_share_feeds"=>"on", "version_date"=>"2012年11月17日", "auto_save"=>"manual"}, "psvr_g"=>Department.nondeleted.gotfid.first.fid.to_s, "psvr_f"=>Course.nondeleted.gotfid.first.fid.to_s}
    assert @response.success?,'登录用户而且用户确实拥有修改权限可以upload_page_auto_save'
    @cw.update_attribute(:uploader_id,User.nondeleted.normal.where(:email.nin=>Setting.admin_emails,:id.ne=>@user.id).first.id)
      post 'upload_page_auto_save',{"presentation"=>{"id"=>@cw.id.to_s, "uptime"=>"", "pdf_filename"=>"某次Kejian.tv会议.pdf", "upload_persentage"=>"100", "title"=>"某次Kejian.tv会议2", "topic"=>" 体育部: 大学生心理素质教育 ", "description"=>"", "keywords"=>"", "teacher"=>"", "other_teacher"=>"", "sort1"=>"lecture_notes", "privacy"=>"public", "reuse"=>"all_rights_reserved", "monetization_style"=>"ads", "enable_overlay_ads"=>"yes", "trueview_instream"=>"on", "allow_syndication"=>"yes", "allow_comments"=>"yes", "allow_comments_detail"=>"all", "allow_comment_ratings"=>"yes", "allow_responses"=>"on", "allow_responses_detail"=>"approval", "allow_embedding"=>"on", "creator_share_feeds"=>"on", "version_date"=>"2012年11月17日", "auto_save"=>"manual"}, "psvr_g"=>Department.nondeleted.gotfid.first.fid.to_s, "psvr_f"=>Course.nondeleted.gotfid.first.fid.to_s}
    assert 401==@response.status,'登录用户且用户没有修改权限不可以upload_page_auto_save'

  end
   
  # todo forum_topicadmin
end
