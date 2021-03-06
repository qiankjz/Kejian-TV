# -*- encoding : utf-8 -*-
require "test_helper"

describe Courseware do
  before do 
    @user1 = User.find('506d54f4e1382375f3000025')
    @user2 = User.find('506d559ee1382375f3000163')
  end
  it "转码完毕的课件改变作者，作者的课件计数作出相应变化" do
    @courseware = Courseware.where(:uploader_id=>@user1.id).non_redirect.nondeleted.normal.is_father.first
    user1_coursewares_uploaded_count_before = @user1.coursewares_uploaded_count
    user2_coursewares_uploaded_count_before = @user2.coursewares_uploaded_count
    @courseware.uploader_id = @user2.id
    @courseware.save(:validate=>false)
    @user1.reload
    @user2.reload
    assert user2_coursewares_uploaded_count_before + 1 == @user2.coursewares_uploaded_count,'课件改了作者，新的作者的课件数应该在保存之后被+1'
    assert user1_coursewares_uploaded_count_before - 1 == @user1.coursewares_uploaded_count,'课件改了作者，旧的作者的课件数应该在保存之后被-1'
    @courseware.uploader_id = @user1.id
    @courseware.save(:validate=>false)
    @user1.reload
    @user2.reload
    assert user2_coursewares_uploaded_count_before == @user2.coursewares_uploaded_count,'可恢复计数，当作者又被改回来了'
    assert user1_coursewares_uploaded_count_before == @user1.coursewares_uploaded_count,'可恢复计数，当作者又被改回来了'
  end
  it "转码没有完成的课件改变老师，老师的课件计数暂不变化" do
    t1 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t2 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t3 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    teacher1_coursewares_count_before = t1.coursewares_count
    teacher2_coursewares_count_before = t2.coursewares_count
    teacher3_coursewares_count_before = t3.coursewares_count
    @courseware = Courseware.new
    @courseware.status=1
    @courseware.uploader_id = @user1.id
    @courseware.teachers = [t1.name,t2.name,t3.name]
    @courseware.save(:validate=>false)
    t1.reload
    t2.reload
    t3.reload
    assert teacher1_coursewares_count_before == t1.coursewares_count,'当改变了老师，但是课件还没有完成转码，不能+1'
    assert teacher2_coursewares_count_before == t2.coursewares_count,'当改变了老师，但是课件还没有完成转码，不能+1'
    assert teacher3_coursewares_count_before == t3.coursewares_count,'当改变了老师，但是课件还没有完成转码，不能+1'
    @courseware.status=0
    @courseware.save(:validate=>false)
    t1.reload
    t2.reload
    t3.reload
    assert teacher1_coursewares_count_before +1== t1.coursewares_count,'当改变了老师，而且课件转码完成了，才+1'
    assert teacher2_coursewares_count_before +1== t2.coursewares_count,'当改变了老师，而且课件转码完成了，才+1'
    assert teacher3_coursewares_count_before +1== t3.coursewares_count,'当改变了老师，而且课件转码完成了，才+1'
    @courseware.teachers = [t1.name,t3.name]
    @courseware.save(:validate=>false)
    t1.reload
    t2.reload
    t3.reload
    assert teacher1_coursewares_count_before +1== t1.coursewares_count,'当改变了老师，而且课件转码完成了，才+1'
    assert teacher2_coursewares_count_before == t2.coursewares_count,'当改变了老师，而且课件转码完成了，才+1'
    assert teacher3_coursewares_count_before +1== t3.coursewares_count,'当改变了老师，而且课件转码完成了，才+1'    
  end
  it "转码没有完成的课件改变作者，作者的课件计数暂不变化" do
    user1_coursewares_uploaded_count_before = @user1.coursewares_uploaded_count
    @courseware = Courseware.new
    @courseware.status=1
    @courseware.uploader_id = @user1.id
    @courseware.save(:validate=>false)
    @user1.reload
    assert user1_coursewares_uploaded_count_before == @user1.coursewares_uploaded_count,'当改变了作者，但是课件还没有完成转码，不能+1'
    @courseware.status=0
    @courseware.save(:validate=>false)
    @user1.reload
    assert user1_coursewares_uploaded_count_before + 1 == @user1.coursewares_uploaded_count,'当改变了作者，而且课件转码完成了，才+1'
  end
  it "课件的
 oooO ↘┏━┓ ↙ Oooo 
 ( 踩)→┃顶┃ ←(踩 ) 
  \\ ( →┃√┃ ← ) / 
　 \\_)↗┗━┛ ↖(_/ 
" do
    @user1.thanked_courseware_ids = []
    @user2.thanked_courseware_ids = []

    @user1.save(:validate=>false)
    @user2.save(:validate=>false)

    @user1.reload
    @user2.reload

    @courseware_user2 = Courseware.where(:uploader_id=>@user2.id).non_redirect.nondeleted.normal.is_father.first
    @courseware_user2.thanked_user_ids = []
    @courseware_user2.disliked_user_ids = []
    @courseware_user2.thanked_count = 0
    @courseware_user2.disliked_count = 0
    @courseware_user2.save(:validate=>false)
    @courseware_user2.reload
    user1_dislike_count = @user1.dislike_count                                 ### 
    user2_disliked_count = @user2.disliked_count
    user1_thank_count = @user1.thank_count
    user2_thanked_count = @user2.thanked_count
    courseware_thanked_count = @courseware_user2.thanked_count
    courseware_disliked_count = @courseware_user2.disliked_count
    ## 被不喜欢
    @courseware_user2.disliked_by_user(@user1)
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    assert user1_dislike_count + 1 == @user1.dislike_count,'不喜欢这个课件的用户的不喜欢表达总次数+1'
    assert user2_disliked_count + 1 == @user2.disliked_count,'被不喜欢这个课件的用户的被不喜欢总次数+1'
    assert courseware_thanked_count == @courseware_user2.thanked_count,'被不喜欢后，课件的喜欢次数保持不变'  
    assert courseware_disliked_count + 1 == @courseware_user2.disliked_count,'被不喜欢后，课件的不喜欢次数+1'
    assert @courseware_user2.disliked_user_ids.include?(@user1.id),'被不喜欢后，课件的不喜欢人记录了不喜欢者'
    refute @courseware_user2.thanked_user_ids.include?(@user1.id),'被不喜欢后，课件的喜欢人就不再包含这个人了'
    ## 不喜欢后，被喜欢
    @user1.thank_courseware(@courseware_user2)
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    assert user1_thank_count + 1 == @user1.thank_count,'之后，这个人又突然喜欢了这个课件，那么这个人的喜欢表达次数+1'
    assert user2_thanked_count + 1 == @user2.thanked_count,'被喜欢这个课件的被喜欢次数+1'
    assert user1_dislike_count == @user1.dislike_count,'不喜欢次数恢复'
    assert user2_disliked_count == @user2.disliked_count,'被不喜欢次数恢复'
    assert courseware_thanked_count + 1 == @courseware_user2.thanked_count,'课件的喜欢数+1'
    assert courseware_disliked_count == @courseware_user2.disliked_count,''
    assert @courseware_user2.thanked_user_ids.include?(@user1.id),'课件记录了喜欢者'
    refute @courseware_user2.disliked_user_ids.include?(@user1.id),'不喜欢者里不再包含这个人'
    ## 喜欢后 被不喜欢
    @courseware_user2.disliked_by_user(@user1)
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    assert user1_dislike_count + 1 == @user1.dislike_count,'不喜欢这个课件的用户的不喜欢表达总次数+1'
    assert user2_disliked_count + 1 == @user2.disliked_count,'被不喜欢这个课件的用户的被不喜欢总次数+1'
    assert courseware_thanked_count +1 -1== @courseware_user2.thanked_count,'原来喜欢，被不喜欢后，课件的喜欢和之前的之前一样了'
    assert courseware_disliked_count + 1 == @courseware_user2.disliked_count,'被不喜欢后，课件的不喜欢次数+1'
    assert @courseware_user2.disliked_user_ids.include?(@user1.id),'被不喜欢后，课件的不喜欢人记录了不喜欢者'
    refute @courseware_user2.thanked_user_ids.include?(@user1.id),'被不喜欢后，课件的喜欢人就不再包含这个人了'
    ##不喜欢后被撤销不喜欢
    @courseware_user2.disliked_by_user(@user1)
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    assert user1_dislike_count == @user1.dislike_count,'撤销不喜欢这个课件的用户的不喜欢表达总次数，就不变了'
    assert user2_disliked_count  == @user2.disliked_count,'撤销被不喜欢这个课件的用户的被不喜欢总次数，不变了'
    assert courseware_thanked_count == @courseware_user2.thanked_count,'撤销被不喜欢后，课件的喜欢次数保持不变'  
    assert courseware_disliked_count  == @courseware_user2.disliked_count,'撤销被不喜欢后，课件的不喜欢次数不变'
    refute @courseware_user2.disliked_user_ids.include?(@user1.id),'撤销被不喜欢后，课件的不喜欢人撤销不喜欢者'
    refute @courseware_user2.thanked_user_ids.include?(@user1.id),'被不喜欢后，课件的喜欢人就不再包含这个人了'
    ## 被喜欢后，撤销喜欢
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    @user1.thank_courseware(@courseware_user2)
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    @user1.thank_courseware(@courseware_user2)
    @user1.reload
    @user2.reload
    @courseware_user2.reload
    assert user1_thank_count == @user1.thank_count,'喜欢后撤销喜欢，这个人又突然喜欢了这个课件，那么这个人的喜欢表达次数不变'
    assert user2_thanked_count  == @user2.thanked_count,'喜欢后撤销，被喜欢这个课件的被喜欢次数不变'
    assert user1_dislike_count == @user1.dislike_count,'不喜欢次数恢复'
    assert user2_disliked_count == @user2.disliked_count,'被不喜欢次数恢复'
    assert courseware_thanked_count == @courseware_user2.thanked_count,'课件的喜欢数'
    assert courseware_disliked_count == @courseware_user2.disliked_count,'此时，喜欢和不喜欢没关系了'
    refute @courseware_user2.thanked_user_ids.include?(@user1.id),'撤销喜欢，课件不记录记录了喜欢者'
    refute @courseware_user2.disliked_user_ids.include?(@user1.id),'不喜欢者里不再包含这个人'
  end
  it "当一个课件的所属课程发生了改变，新旧课程的课件总计数，以及新旧课程所属学院的课件总计数，都应该做出相应改变" do
    c = Courseware.new
    cc = Course.nondeleted.gotfid.first
    cc.department_ins.ua(:coursewares_count,0)
    cc.coursewares_count = 0
    cc.save(:validate=>false)
    cc.reload
    dpt = cc.department_ins.reload
    c.course_fid = cc.fid
    cc_coursewares_count = cc.coursewares_count
    dpt_coursewares_count = dpt.coursewares_count
    c.save(:validate=>false)
    cc.reload
    dpt.reload
    c.reload
    assert cc.coursewares_count == cc_coursewares_count + 1,"当一个课件的所属课程发生了改变，这个课程的课件总计数应+1"
    assert dpt.coursewares_count == dpt_coursewares_count + 1,"当一个课件的所属课程发生了改变，这个课程所属学院的课件总计数应+1"
    # -------------------------
    ccc = Course.nondeleted.gotfid.where(:id.ne=>cc.id,:department_fid.nin=>[dpt.fid,nil]).first
    dpt2 = ccc.department_ins                                       
    c.course_fid = ccc.fid
    ccc_coursewares_count =ccc.coursewares_count
    dpt2_coursewares_count = dpt2.coursewares_count
    c.save(:validate=>false)
    ccc.reload
    cc.reload
    dpt2.reload
    dpt.reload
    c.reload
    assert cc.coursewares_count == cc_coursewares_count,"当一个课件的所属课程发生了改变，那么原来老的课程的课件总计数恢复"
    assert ccc.coursewares_count == ccc_coursewares_count +1,"当一个课件的所属课程发生了改变，新的课程的课件计数+1"
    assert c.department_fid == dpt2.fid,"当一个课件的所属课程发生了改变，课件的学院也应该变为新的学院. Hint: Courseware#calculate_department_fid"
    assert dpt.coursewares_count == dpt_coursewares_count,"当一个课件的所属课程发生了改变，原来老的课程所属学院的课件总计数恢复"  
    assert dpt2.coursewares_count == dpt2_coursewares_count + 1,"当一个课件的所属课程发生了改变，新的课程所属学院的课件总计数应+1"
  end
  it "当一个课件的填了不存在的老师姓名，保存后这个老师就存在了" do
    name = "FUCK#{Time.now.to_i}"
    assert Teacher.where(name:name).first.nil?,'为了测试，这个名字必须不能存在'
    c = Courseware.new
    c.teachers = [name]
    c.save(:validate=>false)
    refute Teacher.where(name:name).first.nil?,'保存后这个老师就存在了'
  end
  it "当一个课件的所属老师发生了改变，这个老师的课件总计数应该做出相应改变" do
    c = Courseware.new
    c.status = 0                      ##需要加上这句话，否则逻辑冲突,如果status!=0不会加1~~Liber加
    cc = Teacher.nondeleted.first
    c.teachers = [cc.name]
    cc_coursewares_count = cc.coursewares_count
    c.save(:validate=>false)
    cc.reload
    c.reload
    assert cc.coursewares_count == cc_coursewares_count + 1,"当一个课件添加到一个老师的时候，这个老师的课件总计数应+1"
    ccc = Teacher.nondeleted.where(:id.ne=>cc.id).first
    c.teachers = [ccc.name]
    ccc_coursewares_count =ccc.coursewares_count
    c.save(:validate=>false)
    ccc.reload
    cc.reload
    assert cc.coursewares_count == cc_coursewares_count,"课件的老师被修改了，那么原来老的老师的课件总计数恢复"
    assert ccc.coursewares_count == ccc_coursewares_count +1,"课件的老师被修改了，新的老师的课件计数+1"
  end
  it "当一个课件的上传人发生了改变，这个上传人的课件总计数应该做出相应改变" do
    c = Courseware.new
    c.status = 0                      ##to psvr需要加上这句话，否则逻辑冲突哦~~Liber加
    cc = User.nondeleted.normal.first
    c.uploader_id = cc.id
    cc_coursewares_uploaded_count = cc.coursewares_uploaded_count
    c.save(:validate=>false)
    cc.reload
    c.reload
    binding.pry if cc.coursewares_uploaded_count !=  1 + cc_coursewares_uploaded_count
    assert cc.coursewares_uploaded_count == cc_coursewares_uploaded_count + 1,"当一个课件添加到一个上传人的时候，这个上传人的课件总计数应+1"
    # -----------------------
    cc2 = User.nondeleted.normal.where(:id.ne=>cc.id).first
    cc2_coursewares_uploaded_count = cc2.coursewares_uploaded_count
    c.uploader_id_candidates = [cc2.id]
    c.save(:validate=>false)
    cc2.reload
    assert cc2.coursewares_uploaded_count == cc2_coursewares_uploaded_count,"当一个课件添加到一个上传人的时候，这个上传人的课件总计数不应该+1"  
    # -----------------------
    ccc = User.nondeleted.normal.where(:id.nin=>[cc.id,cc2.id]).first
    c.uploader_id = ccc.id
    ccc_coursewares_uploaded_count =ccc.coursewares_uploaded_count
    c.save(:validate=>false)
    ccc.reload
    cc.reload
    assert cc.coursewares_uploaded_count == cc_coursewares_uploaded_count,"课件的上传人被修改了，那么原来老的上传人的课件总计数恢复"
    assert ccc.coursewares_uploaded_count == ccc_coursewares_uploaded_count +1,"课件的上传人被修改了，新的上传人的课件计数+1"
  end
  it "一级重定向" do
    @courseware = Courseware.where(:uploader_id=>@user1.id).non_redirect.nondeleted.normal.is_father.first
    @courseware.uploader_id_candidates=[]
    @courseware.redirect_to_id = nil
    @courseware.save(:validate=>false)
    # 与另一人的课件重复
    cw = Courseware.new
    cw.uploader_id = @user2.id
    cw.redirect_to_id = @courseware.id # 注意@courseware属于@user1
    cw.save(:validate=>false)
    cw.reload
    @courseware.reload
    assert 1==@courseware.uploader_id_candidates.count(@user2.id),'用户被加入候选uploader_id'
    # 与本人的课件重复
    cw = Courseware.new
    cw.uploader_id = @user1.id
    cw.redirect_to_id = @courseware.id # 注意@courseware属于@user1
    cw.save(:validate=>false)
    cw.reload
    @courseware.reload
    assert 0==@courseware.uploader_id_candidates.count(@user1.id),'用户与主uploader_id相同则不会被加入候选uploader_id'
    assert @user1.id==cw.uploader_id,'uploader_id依然是uploader_id'
    # Courseware创建后的延迟手工判重
    other_courseware = Courseware.non_redirect.nondeleted.normal.is_father.where(:id.ne=>@courseware.id,:uploader_id.nin=>[@user1.id,@user2.id]).first
    other_courseware_uploader_id = other_courseware.uploader_id
    other_courseware.uploader_id_candidates = []
    other_courseware.save(:validate=>false)
    @courseware.redirect_to_id = other_courseware.id # 注意@courseware属于@user1
    @courseware.save(:validate=>false)
    other_courseware.reload
    assert 1==other_courseware.uploader_id_candidates.count(@user1.id),'用户被加入候选uploader_id'
    assert other_courseware_uploader_id == other_courseware.uploader_id,'uploader_id依然是uploader_id'
    new_cw = Courseware.new
    new_cw.uploader_id = @user1.id
    new_cw.redirect_to_id = other_courseware.id # 注意@courseware属于@user1
    new_cw.save(:validate=>false)
    other_courseware.reload
    assert 1==other_courseware.uploader_id_candidates.count(@user1.id),'用户被已经被加入候选uploader_id，不要重复加入'
    assert other_courseware_uploader_id == other_courseware.uploader_id,'uploader_id依然是uploader_id'
    @courseware.redirect_to_id = nil
    @courseware.save(:validate=>false)
    other_courseware.save(:validate=>false)
    other_courseware.reload
    assert 1==other_courseware.uploader_id_candidates.count(@user1.id),'用户不能被清除于候选uploader_id，因为还有一个课件指向它'       ####To PSVR，此处逻辑可能和下面有冲突==自己的去掉？
    assert other_courseware_uploader_id == other_courseware.uploader_id,'uploader_id依然是uploader_id'
    # ---
    user_n = User.new
    user_n.save(:validate=>false)
    cw_n = Courseware.new
    cw_n.uploader_id = user_n.id
    cw_n.redirect_to_id = other_courseware.id
    cw_n.save(:validate=>false)
    other_courseware.reload
    assert other_courseware.uploader_id_candidates.index(@user1.id) < other_courseware.uploader_id_candidates.index(user_n.id),'先来后到'
    cw_n.redirect_to_id = nil
    cw_n.save(:validate=>false)
    # ---    
    new_cw.uploader_id = @user2.id
    new_cw.save(:validate=>false)
    other_courseware.reload
    assert 0==other_courseware.uploader_id_candidates.count(@user1.id),'用户被清除于候选uploader_id，因为没有任何课件指向它了'
    assert 1==other_courseware.uploader_id_candidates.count(@user2.id),'当已经设置了redirect_to_id的时候修改uploader_id，需要设置新的uploader_id_candidates'
    assert other_courseware_uploader_id == other_courseware.uploader_id,'uploader_id依然是uploader_id'
    # 已转向的情况下再转向
    new_cw2 = Courseware.new
    new_cw2.uploader_id = @user1.id
    new_cw2.save(:validate=>false)
    new_cw.redirect_to_id = new_cw2.id # 注意@courseware属于@user1
    new_cw.save(:validate=>false)
    other_courseware.reload
    binding.pry if !other_courseware.uploader_id_candidates.empty?
    assert other_courseware.uploader_id_candidates.empty?,'没有任何课件指向other_courseware了'  ##
    assert other_courseware_uploader_id == other_courseware.uploader_id,'uploader_id依然是uploader_id'    
    new_cw2.reload
    assert [@user2.id] == new_cw2.uploader_id_candidates,'new_cw2的uploader_id_candidates'
    assert new_cw2.uploader_id == @user1.id,'uploader_id依然是uploader_id'    
  end
  it "多级重定向消除为一级重定向 c.f redirect_to_id_op" do
    @courseware = Courseware.where(:uploader_id=>@user1.id).non_redirect.nondeleted.normal.is_father.first
    cw1 = Courseware.new;cw1.uploader_id = @user1.id;
    cw2 = Courseware.new;cw2.uploader_id = @user2.id;
    cw3 = Courseware.new;u3=User.new;u3.save(:validate=>false);cw3.uploader_id = u3.id;
    cw4 = Courseware.new;u4=User.new;u4.save(:validate=>false);cw4.uploader_id = u4.id;
    cw1.redirect_to_id = @courseware.id
    cw2.redirect_to_id = cw1.id
    cw3.redirect_to_id = cw2.id
    cw4.redirect_to_id = cw2.id
    cw1.save(:validate=>false)
    cw2.save(:validate=>false)
    cw3.save(:validate=>false)
    cw4.save(:validate=>false)
    cw1.reload
    cw2.reload
    cw3.reload
    cw4.reload
    @courseware.reload
    assert cw1.redirect_to_id == @courseware.id,'连环重定向需传递闭包'
    assert cw2.redirect_to_id == @courseware.id,'连环重定向需传递闭包'
    assert cw3.redirect_to_id == @courseware.id,'连环重定向需传递闭包'
    assert cw4.redirect_to_id == @courseware.id,'连环重定向需传递闭包'
    refute 1==@courseware.uploader_id_candidates.count(@user1.id),'连环重定向需传递闭包'
    assert 1==@courseware.uploader_id_candidates.count(@user2.id),'连环重定向需传递闭包'
    assert 1==@courseware.uploader_id_candidates.count(u3.id),'连环重定向需传递闭包'
    assert 1==@courseware.uploader_id_candidates.count(u4.id),'连环重定向需传递闭包'
    # ---
    @courseware.redirect_to_id = cw2.id
    @courseware.save(:validate=>false)
    assert @courseware.redirect_to_id.nil?,'发现重定向环时应改设此定向关系为nil'
  end
  it '课件的slides_count发生改变的时候，需要通知引用它的播放列表更新总页数' do
    cw1 = Courseware.new;cw1.save(:validate=>false)
    cw2 = Courseware.new;cw2.save(:validate=>false)
    user_n = User.new
    user_n.save(:validate=>false)
    play_list = PlayList.locate(@user1.id,"PL#{Time.now.to_i}#{rand}")
    play_list.add_one_thing(cw1.id)
    play_list.add_one_thing(cw2.id)
    play_list.reload
    assert 0==play_list.content_total_pages,'课件没有页，播放列表总页数为0'
    cw1.update_attribute(:slides_count,101)
    play_list.reload
    assert 101==play_list.content_total_pages,'增长了101页'
    cw2.update_attribute(:slides_count,101)
    play_list.reload
    assert 101*2==play_list.content_total_pages,'又增长了101页'
  end
  it "课件状态转变状态之时，需要通知引用它的播放列表更新状态" do
    user_n = User.new
    user_n.save(:validate=>false)
    cw1 = Courseware.new
    cw1.status=1
    cw1.ktvid = '5058960ce13823076c00002e'
    cw1.save(:validate=>false)
    cw2 = Courseware.new
    cw2.ktvid = '5058960ce13823076c00002e'
    cw2.status=2
    cw2.save(:validate=>false)
    cw3 = Courseware.new
    cw3.ktvid = nil
    cw3.status=0
    cw3.save(:validate=>false)
    play_list = PlayList.locate(@user1.id,"PL#{Time.now.to_i}#{rand}")
    play_list.add_one_thing(cw1.id)
    play_list.add_one_thing(cw2.id)
    play_list.add_one_thing(cw3.id)
    cw1.update_attribute(:status,0)
    play_list.reload
    refute 0==play_list.status,'cw2和cw3未达到正常状态，所以play_list也不正常'
    cw2.update_attribute(:status,0)
    cw3.update_attribute(:ktvid,'5058960ce13823076c00002e')
    play_list.reload
    assert 0==play_list.status,'cw1和cw2达到了正常状态，课件改变状态应通知引用它的播放列表，之后play_list也被通知为正常了'    
    cw2.update_attribute(:status,1)
    play_list.reload
    refute 0==play_list.status,'cw2进入不正常状态，play_list也不正常了'    
    cw2.update_attribute(:status,0)
    play_list.reload
    assert 0==play_list.status,'cw2进入正常状态，play_list也正常了'    
    cw1.update_attribute(:ktvid,'')
    play_list.reload
    refute 0==play_list.status,'cw2进入不正常状态，play_list也不正常了'    
  end
  it "软删除之前判断是否有上传人候选，是真要删还是假要删？ -- Courseware.before_soft_delete" do
    user_n = User.new
    user_n.save(:validate=>false)
    cw0 = Courseware.new
    cw0.status = 0                                                                ## to psvr 必须是转完码的，否则不会计数
    cw0.uploader_id = user_n.id
    cw0.save(:validate=>false)
    ret = cw0.instance_eval(&Courseware.before_soft_delete)
    cw0.reload
    user_n.reload
    refute false==ret,'没有上传人候选，before_soft_delete必须不能返回false以让软删除的进一步执行。'
    cw1 = Courseware.new;cw1.uploader_id = @user2.id;cw1.status = 0;            ## to psvr 这俩也是，必须是转完码的，否则不会计数
    cw2 = Courseware.new;cw2.uploader_id = @user2.id;cw2.status = 0;
    cw2.redirect_to_id = nil
    cw2.save(:validate=>false)
    cw1.redirect_to_id = cw2.id
    cw1.save(:validate=>false)
    cw1.reload
    cw2.reload
    ret = cw2.instance_eval(&Courseware.before_soft_delete)
    cw2.reload
    refute false==ret,'没有上传人候选（都是自己人），before_soft_delete必须不能返回false以让软删除的进一步执行。'
    cw1.uploader_id = @user1.id;
    cw1.save(:validate=>false)
    cw0.redirect_to_id = cw2.id
    cw0.save(:validate=>false)
    @user2.reload
    cw0.reload
    cw1.reload
    cw2.reload
    cw2_uploader_id_candidates = cw2.uploader_id_candidates.clone
    user2_coursewares_uploaded_count = @user2.coursewares_uploaded_count
    user_n_coursewares_uploaded_count = user_n.coursewares_uploaded_count
    ret = cw2.instance_eval(&Courseware.before_soft_delete)
    assert false==ret,'有上传人候选，before_soft_delete必须返回false以阻止软删除的进一步执行！'
    cw2.reload
    assert cw2.uploader_id == cw2_uploader_id_candidates[0],'before_soft_delete虽然返回了false，但是@user2从此被剥夺了此课件的拥有权，第1个候选人继承拥有权'
    @user2.reload
    assert user2_coursewares_uploaded_count-1 == @user2.coursewares_uploaded_count,'@user2被剥夺了此课件的拥有权的计数体现'
    ret = cw2.instance_eval(&Courseware.before_soft_delete)
    assert false==ret,'有上传人候选，before_soft_delete必须返回false以阻止软删除的进一步执行！'
    cw2.reload
    assert cw2.uploader_id == cw2_uploader_id_candidates[1],'before_soft_delete虽然返回了false，但是user_n从此被剥夺了此课件的拥有权，第2个候选人继承拥有权'
    user_n.reload
    assert user_n_coursewares_uploaded_count - 1 == user_n.coursewares_uploaded_count,'user_n被剥夺此课件的拥有权的计数体现'
  end
  it "异步清理" do
    @user1.thanked_courseware_ids = []
    @user2.thanked_courseware_ids = []
    @user1.save(:validate=>false)
    @user2.save(:validate=>false)
    @user1.reload
    @user2.reload
    t1 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t2 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t3 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    c = Course.nondeleted.gotfid.first
    dpt = c.department_ins
    user_n = User.new
    user_n.save(:validate=>false)
    pl1 = PlayList.locate(@user1.id,"PL#{Time.now.to_i}#{rand}")
    pl2 = PlayList.locate(user_n.id,"PL#{Time.now.to_i}#{rand}")
    cw_kid1 = Courseware.new;cw_kid1.is_children=true;cw_kid1.uploader_id=user_n.id;cw_kid1.save(:validate=>false)
    cw_kid2 = Courseware.new;cw_kid2.is_children=true;cw_kid1.uploader_id=user_n.id;cw_kid2.save(:validate=>false)
    cw_kid3 = Courseware.new;cw_kid3.is_children=true;cw_kid1.uploader_id=user_n.id;cw_kid3.save(:validate=>false)
    crazy_cw = Courseware.new
    crazy_cw.tree = {
      "id" => 0, "item" => [{
        "id" => "Root", "open" => "1", "select" => "1", "child" => "1", "text" => "TEST－孙TEST", "item" => [{
          "id" => "dir_WjO8AwcguC", "child" => "1", "open" => "1", "text" => "TEST－孙TEST", "item" => [{
            "id" => cw_kid1.id.to_s, "text" => "CG14-TESTkid1.ppt", "im0" => "iconGraph.gif"
          },{
            "id" => cw_kid2.id.to_s, "text" => "CG14-TESTkid2.ppt", "im0" => "iconGraph.gif"
          },{
            "id" => cw_kid3.id.to_s, "text" => "CG14-TESTkid3.ppt", "im0" => "iconGraph.gif"
          }]
        }]
      }]
    }
    crazy_cw.status = 0
    crazy_cw.uploader_id = user_n.id
    crazy_cw.course_fid = c.fid
    crazy_cw.teachers = [t1.name,t2.name,t3.name]
    crazy_cw.save(:validate=>false)
    pl1.add_one_thing(crazy_cw.id)
    pl2.add_one_thing(crazy_cw.id)
    crazy_cw.disliked_by_user(@user1)
    @user2.thank_courseware(crazy_cw)
    success_cm1,cm1 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>crazy_cw.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}"}}.with_indifferent_access,@user1)
    success_cm2,cm2 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>crazy_cw.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}",'replied_to_comment_id'=>cm1.id.to_s}}.with_indifferent_access,@user2)
    success_cm3,cm3 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>crazy_cw.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}"}}.with_indifferent_access,user_n)
    # 1. 预检--------------    
    crazy_cw.reload
    crazy_cw.uploader.reload
    t1.reload
    t2.reload
    t3.reload
    user_n.reload
    @user1.reload
    @user2.reload
    c.reload
    dpt.reload
    pl1.reload
    pl2.reload
    cw_kid1.reload
    cw_kid2.reload
    cw_kid3.reload
    cm1.reload
    cm2.reload
    cm3.reload
    b11 = t1.coursewares_count
    b12 = t2.coursewares_count
    b13 = t3.coursewares_count
    b2 = c.coursewares_count
    b3 = dpt.coursewares_count
    b5 = @user1.dislike_count
    b6 = @user2.thank_count
    b7 = crazy_cw.uploader.disliked_count
    b8 = crazy_cw.uploader.thanked_count
    # 2. 清理！！！--------------
    crazy_cw.asynchronously_clean_me
    # 3. 重检--------------
    crazy_cw.reload
    crazy_cw.uploader.reload
    t1.reload
    t2.reload
    t3.reload
    user_n.reload
    @user1.reload
    @user2.reload
    c.reload
    dpt.reload
    pl1.reload
    pl2.reload
    cw_kid1.reload
    cw_kid2.reload
    cw_kid3.reload
    cm1.reload
    cm2.reload
    cm3.reload
    assert 0 == user_n.coursewares_uploaded_count,'just like new'
    assert 0 == user_n.thank_count,'just like new'
    assert 0 == user_n.dislike_count,'just like new'
    assert b11 - 1 == t1.coursewares_count,'撤销老师1的课件计数'
    assert b12 - 1 == t2.coursewares_count,'撤销老师2的课件计数'
    assert b13 - 1 == t3.coursewares_count,'撤销老师3的课件计数'
    assert b2 - 1 == c.coursewares_count,'课程的课件被删了，课程课件计数-1'
    assert b3 - 1 == dpt.coursewares_count,'院系的课件被删了，院系课件计数-1'
    assert b5 - 1 == @user1.dislike_count,'撤销踩计数'
    assert b6 - 1 == @user2.thank_count,'撤销顶计数'
    assert b7 - 1 == crazy_cw.uploader.disliked_count
    assert b8 - 1 == crazy_cw.uploader.thanked_count
    refute pl1.content.include?(crazy_cw.id),'不管是谁的播放列表引用了这个课件，课件被删后不能留有脏引用'
    refute pl2.content.include?(crazy_cw.id),'不管是谁的播放列表引用了这个课件，课件被删后不能留有脏引用'
    refute @user2.thanked_courseware_ids.include?(crazy_cw.id),'顶了这个课件，课件被删后不能留有脏引用'
    assert (cw_kid1.soft_deleted? or cw_kid1.uploader_id != crazy_cw.uploader_id),'软删除传播到了这个课件的每个子课件'
    assert (cw_kid2.soft_deleted? or cw_kid2.uploader_id != crazy_cw.uploader_id),'软删除传播到了这个课件的每个子课件'
    assert (cw_kid3.soft_deleted? or cw_kid3.uploader_id != crazy_cw.uploader_id),'软删除传播到了这个课件的每个子课件'
    assert cm1.soft_deleted?,'软删除传播到了这个课件的每个评论'
    assert cm2.soft_deleted?,'软删除传播到了这个课件的每个评论'
    assert cm3.soft_deleted?,'软删除传播到了这个课件的每个评论'
    refute pl1.soft_deleted?,'课件没了，播放列表不能没'
    refute pl2.soft_deleted?,'课件没了，播放列表不能没'
    refute 0==pl1.status,'列表空了，播放列表自然不是正常的'
    refute 0==pl2.status,'列表空了，播放列表自然不是正常的'
    refute c.soft_deleted?,'课件没了，课程不能没'
    refute dpt.soft_deleted?,'课件没了，学院不能没'
  end  
  it "课件的一阶索引" do
    user_n = User.new
    user_n.save(:validate=>false)
    cw0 = Courseware.new
    title = "pppppssssssvvvvvvrrrrrcwcw#{Courseware.count+1}"
    cw0.title = title
    cw0.save(:validate=>false)
    refute Redis::Search.query("Courseware", cw0.title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息不全，不建立一阶索引'
    cw0.status = 0
    cw0.privacy = 0
    tch="TCH#{Time.now.to_i}#{rand}"
    cw0.teachers = [tch]
    cc = Course.nondeleted.gotfid
    cw0.course_fid = cc[0].fid
    cw0.save(:validate=>false)
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息齐全后，保存即建立这个课件的一阶索引'
  
    cw0.update_attribute(:status,1)
    refute Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息改为不正常，删除其一阶索引'
    cw0.update_attribute(:status,0)
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息恢复正常，恢复其一阶索引'    
  
    cw0.update_attribute(:privacy,1)
    refute Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息改为不正常，删除其一阶索引'
    cw0.update_attribute(:privacy,0)
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息恢复正常，恢复其一阶索引'    
  
    cw0.update_attribute(:title,'')
    refute Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息改为不正常，删除其一阶索引'
    cw0.update_attribute(:title, title)
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息恢复正常，恢复其一阶索引'    
    
    cw0_teachers = cw0.teachers
    cw0_course_fid = cw0.course_fid
    cw0.update_attribute(:teachers,[])
    cw0.update_attribute(:course_fid,nil)
    refute Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息改为不正常，删除其一阶索引'
    cw0.update_attribute(:teachers,cw0_teachers)
    cw0.update_attribute(:course_fid,cw0_course_fid)
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '信息恢复正常，恢复其一阶索引'    
    
    title2 = title.reverse
    assert title2!=title
    cw0.update_attribute(:title, title2)
    refute Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '标题改了，老标题索引不再存在'
    assert Redis::Search.query("Courseware", title2).try(:[],0).try(:[],'id') == cw0.id.to_s, '标题改了，新标题索引存在'
    cw0.update_attribute(:title, title)
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '标题recover'
            
    cw0.reload
    old_alias = cw0.redis_search_alias
    tch2="TCH#{Time.now.to_i}#{rand}"
    cw0.update_attribute(:course_fid, cc[1].fid)
    cw0.update_attribute(:teachers, [tch2])
    cw0.reload
    new_alias = cw0.redis_search_alias
    assert old_alias!=new_alias,'老师、课程名改了，新索引键需反应此修改'
    assert new_alias.include?(tch2),'老师、课程名改了，新索引键需反应此修改'
    assert new_alias.include?(cc[1].name),'老师、课程名改了，新索引键需反应此修改'
    refute Redis::Search.query("Courseware", old_alias).try(:[],0).try(:[],'id') == cw0.id.to_s, '老师、课程名改了，老索引不再存在'
    assert Redis::Search.query("Courseware", new_alias).try(:[],0).try(:[],'id') == cw0.id.to_s, '老师、课程名改了，新索引存在'
    assert 0==Redis::Search.query("Courseware", new_alias).try(:[],0).try(:[],'slides_count'), '索引要记录正确的页数'
    cw0.update_attribute(:slides_count,100)
    assert 100==Redis::Search.query("Courseware", new_alias).try(:[],0).try(:[],'slides_count'), '索引要记录正确的页数'
    
    assert Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '软删除之后删除课件的一阶索引'
    cw0.reload
    cw0.instance_eval(&Courseware.after_soft_delete)
    refute Redis::Search.query("Courseware", title).try(:[],0).try(:[],'id') == cw0.id.to_s, '软删除之后删除课件的一阶索引'
  end
  it "课件的二阶索引" do
    Courseware.reconstruct_indexes!
    q=Sidekiq::Queue.new('redundancy')
    Sidekiq.redis do |x|
      x.flushall
    end
  
    body = "FUCKFUCKFUUUUUUUUUUUCKpgpg#{Page.count+1}"
    user_n = User.new
    user_n.save(:validate=>false)
    cw0 = Courseware.new
    title = "pppppssssssvvvvvvrrrrrcwcw#{Courseware.count+1}"
    cw0.title = title
    cw0.save(:validate=>false)
    Courseware.tire.index.refresh;refute Courseware.psvr_search(1,1,{q:cw0.title}).first.try(:id) == cw0.id.to_s, '信息不全，不建立二阶索引'
    cw0.status = 0
    cw0.privacy = 0
    tch="TCH#{Time.now.to_i}#{rand}"
    cw0.teachers = [tch]
    cc = Course.nondeleted.gotfid
    cw0.course_fid = cc[0].fid
    cw0.save(:validate=>false)
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息齐全后，保存即建立这个课件的二阶索引'

    assert q.find{|x| x.item['args']==["Page", nil, "do_index_them_for_cw", cw0.id.to_s]}, '保存建立这个课件的二阶索引后，因为是隐藏性变更，需要让Page建立索引'
    Sidekiq.redis do |x|
      x.flushall
    end

    cw0.update_attribute(:status,1)
    Courseware.tire.index.refresh;refute Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息改为不正常，删除其二阶索引'
    assert q.find{|x| x.item['args']==["Page", nil, "do_unindex_them_for_cw", cw0.id.to_s]}, '删除其二阶索引后，因为是隐藏性变更，需要让Page删除索引'
    Sidekiq.redis do |x|
      x.flushall
    end

    cw0.update_attribute(:status,0)
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息恢复正常，恢复其二阶索引'    
    assert q.find{|x| x.item['args']==["Page", nil, "do_index_them_for_cw", cw0.id.to_s]}, '恢复其二阶索引后，因为是隐藏性变更，需要让Page建立索引'  
    Sidekiq.redis do |x|
      x.flushall
    end

    cw0.update_attribute(:privacy,1)
    Courseware.tire.index.refresh;refute Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息改为不正常，删除其二阶索引'
    cw0.update_attribute(:privacy,0)
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息恢复正常，恢复其二阶索引'
    cw0.update_attribute(:title,'')
    Courseware.tire.index.refresh;refute Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息改为不正常，删除其二阶索引'
    cw0.update_attribute(:title, title)
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '信息恢复正常，恢复其二阶索引'    
    
    title2 = title.reverse
    assert title2!=title
    cw0.update_attribute(:title, title2)
    Courseware.tire.index.refresh;refute Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '标题改了，老标题索引不再存在'
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title2}).first.try(:id) == cw0.id.to_s, '标题改了，新标题索引存在'
    cw0.update_attribute(:title, title)
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '标题recover'

    
    Courseware.tire.index.refresh;assert Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '软删除之后删除课件的索引'
    cw0.reload
    cw0.instance_eval(&Courseware.after_soft_delete)
    Courseware.tire.index.refresh;refute Courseware.psvr_search(1,1,{q:title}).first.try(:id) == cw0.id.to_s, '软删除之后删除课件的索引'
    
  end
end

