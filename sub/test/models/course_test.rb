# -*- encoding : utf-8 -*-
require 'test_helper'
describe Course do
  before do
    @user1 = User.find('506d5558e1382375f30000dc')
    @user2 = User.find('506d559ee1382375f3000163')
  end
  it "创建新课程并添加到某学院（上传课件时如果课程不够用，需要添加新课程）" do
    dpt = Department.first
    dpt_courses_count = dpt.courses_count
    c = Course.new
    c.department_fid = dpt.fid
    c.save(:validate=>false)
    dpt.reload
    assert dpt_courses_count +1 == dpt.courses_count,'新的课程属于某个学院，这个学院的课程总数+1'
  end
  it "被添加老师（上传课件时如果老师不够用，需要添加新老师）" do
    dpt = Department.first
    c = Course.new
    c.department_fid = dpt.fid
    c.save(:validate=>false)
    t1 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t2 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t3 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t1.courses_count = 0
    t2.courses_count = 0
    t3.courses_count = 0
    t1.save(:validate=>false)
    t2.save(:validate=>false)
    t3.save(:validate=>false)
    c.update_attribute(:teachers,[t1.name,t2.name])
    t1.reload
    t2.reload
    t3.reload
    assert 1==t1.courses_count,'课程属于新的老师，这个老师的课程计数相应调整'
    assert 1==t2.courses_count,'课程属于新的老师，这个老师的课程计数相应调整'
    assert 0==t3.courses_count,'课程属于新的老师，这个老师的课程计数相应调整'
    c.update_attribute(:teachers,[t2.name,t3.name])
    t1.reload
    t2.reload
    t3.reload
    assert 0==t1.courses_count,'课程属于新的老师，这个老师的课程计数相应调整'
    assert 1==t2.courses_count,'课程属于新的老师，这个老师的课程计数相应调整'
    assert 1==t3.courses_count,'课程属于新的老师，这个老师的课程计数相应调整'
  end
  it "DZ" do
    # todo
  end
  it "软删除之前判断是否有课件依赖于这个课程" do
    user_n = User.new
    user_n.save(:validate=>false)
    dpt = Department.first
    c = Course.new
    c.department_fid = dpt.fid
    c.save(:validate=>false)
    c_other = Course.nondeleted.where(:id.ne=>c.id).first
    ret = c.instance_eval(&Course.before_soft_delete)
    refute false==ret,'没有任何课件依赖，可以进行删除'
    cw=Courseware.non_redirect.nondeleted.normal.is_father.first
    cw.course_fid = c.fid
    cw.save(:validate=>false)
    c.reload
    ret = c.instance_eval(&Course.before_soft_delete)
    assert false==ret,'增加了课件依赖，不能进行删除'
    cw.course_fid = c_other.id
    cw.save(:validate=>false)
    c.reload
    ret = c.instance_eval(&Course.before_soft_delete)
    refute false==ret,'解除课件依赖，可以进行删除'
  end
  it "异步清理" do
    @user1.followed_course_fids=[]
    @user1.save(:validate=>false)
    @user1.reload
    @user2.followed_course_fids=[]
    @user2.save(:validate=>false)
    @user2.reload
    dpt = Department.first
    t1 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t2 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    t3 = Teacher.locate("TCH#{Time.now.to_i}#{rand}")
    crazy_course = Course.new
    crazy_course.department_fid = dpt.fid
    crazy_course.teachers = [t1.name,t2.name,t3.name]
    crazy_course.save(:validate=>false)
    @user1.follow_course(crazy_course)
    @user2.follow_course(crazy_course)
    # 1. 预检--------------    
    crazy_course.reload
    dpt.reload
    @user1.reload
    @user2.reload
    t1.reload
    t2.reload
    t3.reload
    dpt_courses_count = dpt.courses_count
    t1_courses_count = t1.courses_count
    t2_courses_count = t2.courses_count
    t3_courses_count = t3.courses_count
    # 2. 清理！！！-------------- 
    crazy_course.asynchronously_clean_me
    # 3. 重检--------------
    crazy_course.reload
    dpt.reload
    @user1.reload
    @user2.reload
    t1.reload
    t2.reload
    t3.reload
    assert crazy_course.soft_deleted?
    refute @user1.followed_course_fids.include?(crazy_course.id),'清除关注课程赃引用'
    refute @user2.followed_course_fids.include?(crazy_course.id),'清除关注课程赃引用'
    assert dpt_courses_count - 1 == dpt.courses_count,'所属院系的课程计数还原'
    assert t1_courses_count - 1 == t1.courses_count,'老师的课程计数还原'
    assert t2_courses_count - 1 == t2.courses_count,'老师的课程计数还原'
    assert t3_courses_count - 1 == t3.courses_count,'老师的课程计数还原'    
  end
end
