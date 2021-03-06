# -*- encoding : utf-8 -*-
require "test_helper"
describe Comment do
  before do
    @user1 = User.find('506d5558e1382375f30000dc')
    @user2 = User.find('506d559ee1382375f3000163')
  end
  
  it "评论人与被评论物体的评论计数 +1" do
    @courseware1 = Courseware.non_redirect.nondeleted.normal.is_father.first
    user1_comments_count = @user1.comments_count
    courseware1_comments_count = @courseware1.comments_count
    c = Comment.new
    c.user_id = @user1.id
    c.commentable_id = @courseware1.id
    c.commentable_type = 'Courseware'
    c.save(:validate=>false)
    @user1.reload
    @courseware1.reload
    assert user1_comments_count + 1 == @user1.comments_count,'用户评论后用户的评论数字应该+1'
    assert courseware1_comments_count + 1 == @courseware1.comments_count,'用户名评论后被评论的课件的评论数字应+1'    
  end
  
  it "对课件进行评论" do
    @courseware1 = Courseware.non_redirect.nondeleted.normal.is_father.first
    success_cm1,cm1 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}"}}.with_indifferent_access,@user1)
    success_cm2,cm2 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}",'replied_to_comment_id'=>cm1.id.to_s}}.with_indifferent_access,@user2)
    success_cm3,cm3 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}"}}.with_indifferent_access,@user1)
    assert success_cm1,'成功保存评论'
    assert success_cm2,'成功保存评论'
    assert success_cm3,'成功保存评论'
    assert @courseware1.comments.collect(&:body).include?(cm1.body),'成功评论了课件'
    assert @courseware1.comments.collect(&:body).include?(cm2.body),'成功评论了课件'
    assert @courseware1.comments.collect(&:body).include?(cm3.body),'成功评论了课件'
  end


  it "评论的
 oooO ↘┏━┓ ↙ Oooo 
 ( 踩)→┃顶┃ ←(踩 ) 
  \\ ( →┃√┃ ← ) / 
　 \\_)↗┗━┛ ↖(_/ 
" do
    @courseware1 = Courseware.non_redirect.nondeleted.normal.is_father.first
    success_comment_user2,@comment_user2 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}"}}.with_indifferent_access,@user2)
    assert success_comment_user2
    @comment_user2.voteup_user_ids = []
    @comment_user2.votedown_user_ids = []
    @comment_user2.voteup = 0
    @comment_user2.votedown = 0
    @comment_user2.save(:validate=>false)
    @comment_user2.reload

    user1_dislike_count = @user1.dislike_count
    user2_disliked_count = @user2.disliked_count
    user1_thank_count = @user1.thank_count
    user2_thanked_count = @user2.thanked_count
    comment_thanked_count = @comment_user2.voteup
    comment_disliked_count = @comment_user2.votedown
    ## 被不喜欢
    @comment_user2.disliked_by_user(@user1)
    @user1.reload
    @user2.reload
    @comment_user2.reload
    assert user1_dislike_count + 1 == @user1.dislike_count,'不喜欢这个课件的用户的不喜欢表达总次数+1'
    assert user2_disliked_count + 1 == @user2.disliked_count,'被不喜欢这个课件的用户的被不喜欢总次数+1'
    assert comment_thanked_count == @comment_user2.voteup,'被不喜欢后，课件的喜欢次数保持不变'  
    assert comment_disliked_count + 1 == @comment_user2.votedown,'被不喜欢后，课件的不喜欢次数+1'
    assert @comment_user2.votedown_user_ids.include?(@user1.id),'被不喜欢后，课件的不喜欢人记录了不喜欢者'
    refute @comment_user2.voteup_user_ids.include?(@user1.id),'被不喜欢后，课件的喜欢人就不再包含这个人了'
    ## 不喜欢后，被喜欢
    @user1.like_comment(@comment_user2)
    @user1.reload
    @user2.reload
    @comment_user2.reload
    assert user1_thank_count + 1 == @user1.thank_count,'之后，这个人又突然喜欢了这个课件，那么这个人的喜欢表达次数+1'
    assert user2_thanked_count + 1 == @user2.thanked_count,'被喜欢这个课件的被喜欢次数+1'
    assert user1_dislike_count == @user1.dislike_count,'不喜欢次数恢复'
    assert user2_disliked_count == @user2.disliked_count,'被不喜欢次数恢复'
    assert comment_thanked_count + 1 == @comment_user2.voteup,'课件的喜欢数+1'
    assert comment_disliked_count == @comment_user2.votedown,''
    assert @comment_user2.voteup_user_ids.include?(@user1.id),'课件记录了喜欢者'
    refute @comment_user2.votedown_user_ids.include?(@user1.id),'不喜欢者里不再包含这个人'
    ## 喜欢后 被不喜欢
    @comment_user2.disliked_by_user(@user1)
    @user1.reload
    @user2.reload
    @comment_user2.reload
    assert user1_dislike_count + 1 == @user1.dislike_count,'不喜欢这个课件的用户的不喜欢表达总次数+1'
    assert user2_disliked_count + 1 == @user2.disliked_count,'被不喜欢这个课件的用户的被不喜欢总次数+1'
    assert comment_thanked_count +1 -1== @comment_user2.voteup,'原来喜欢，被不喜欢后，课件的喜欢和之前的之前一样了'
    assert comment_disliked_count + 1 == @comment_user2.votedown,'被不喜欢后，课件的不喜欢次数+1'
    assert @comment_user2.votedown_user_ids.include?(@user1.id),'被不喜欢后，课件的不喜欢人记录了不喜欢者'
    refute @comment_user2.voteup_user_ids.include?(@user1.id),'被不喜欢后，课件的喜欢人就不再包含这个人了'
    ##不喜欢后被撤销不喜欢
    @comment_user2.disliked_by_user(@user1)
    @user1.reload
    @user2.reload
    @comment_user2.reload
    assert user1_dislike_count == @user1.dislike_count,'撤销不喜欢这个课件的用户的不喜欢表达总次数，就不变了'
    assert user2_disliked_count  == @user2.disliked_count,'撤销被不喜欢这个课件的用户的被不喜欢总次数，不变了'
    assert comment_thanked_count == @comment_user2.voteup,'撤销被不喜欢后，课件的喜欢次数保持不变'  
    assert comment_disliked_count  == @comment_user2.votedown,'撤销被不喜欢后，课件的不喜欢次数不变'
    refute @comment_user2.votedown_user_ids.include?(@user1.id),'撤销被不喜欢后，课件的不喜欢人撤销不喜欢者'
    refute @comment_user2.voteup_user_ids.include?(@user1.id),'被不喜欢后，课件的喜欢人就不再包含这个人了'
    ## 被喜欢后，撤销喜欢
    @user1.reload
    @user2.reload
    @comment_user2.reload
    @user1.like_comment(@comment_user2)
    @user1.reload
    @user2.reload
    @comment_user2.reload
    @user1.like_comment(@comment_user2)
    @user1.reload
    @user2.reload
    @comment_user2.reload
    assert user1_thank_count == @user1.thank_count,'喜欢后撤销喜欢，这个人又突然喜欢了这个课件，那么这个人的喜欢表达次数不变'
    assert user2_thanked_count  == @user2.thanked_count,'喜欢后撤销，被喜欢这个课件的被喜欢次数不变'
    assert user1_dislike_count == @user1.dislike_count,'不喜欢次数恢复'
    assert user2_disliked_count == @user2.disliked_count,'被不喜欢次数恢复'
    assert comment_thanked_count == @comment_user2.voteup,'课件的喜欢数'
    assert comment_disliked_count == @comment_user2.votedown,'此时，喜欢和不喜欢没关系了'
    refute @comment_user2.voteup_user_ids.include?(@user1.id),'撤销喜欢，课件不记录记录了喜欢者'
    refute @comment_user2.votedown_user_ids.include?(@user1.id),'不喜欢者里不再包含这个人'
  end

  it "异步清理" do
    @courseware1 = Courseware.non_redirect.nondeleted.normal.is_father.first
    # 以下评论由@user2创建
    success_crazy_comment,crazy_comment = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}"}}.with_indifferent_access,@user2)
    assert success_crazy_comment
    # 以下评论由@user1创建
    success_comment_kid1,comment_kid1 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}",'replied_to_comment_id'=>crazy_comment.id}}.with_indifferent_access,@user1)
    success_comment_kid2,comment_kid2 = Comment.real_create({:comment => {"commentable_type"=>"Courseware","commentable_id"=>@courseware1.id.to_s,"body"=>"#{Time.now.to_i}#{rand.to_s}",'replied_to_comment_id'=>crazy_comment.id}}.with_indifferent_access,@user1)
    assert success_comment_kid1
    assert success_comment_kid2
    crazy_comment.disliked_by_user(@user1)
    @user2.like_comment(crazy_comment)
    # 1. 预检--------------    
    crazy_comment.reload
    @user1.reload
    @user2.reload
    comment_kid1.reload
    comment_kid2.reload
    @courseware1.reload
    d1 = @user1.dislike_count
    d2 = @user2.thank_count
    d3 = @user1.comments_count
    d4 = @user2.comments_count
    d5 = @courseware1.comments_count
    # 2. 清理！！！--------------    
    crazy_comment.asynchronously_clean_me
    # 3. 重检--------------
    crazy_comment.reload
    @user1.reload
    @user2.reload
    comment_kid1.reload
    comment_kid2.reload
    @courseware1.reload
    # assert comment_kid1.soft_deleted?,'软删除传播至子评论'                            ###to psvr 子评论不应该被删除，就和微博删除了评论不一定被删除一样。
    # assert comment_kid2.soft_deleted?,'软删除传播至子评论'
    assert d1 - 1 == @user1.dislike_count,'评论的投票人计数复原'
    assert d2 - 1 == @user2.thank_count,'评论的投票人计数复原'
    assert d4 - 1 == @user2.comments_count,'评论的创建人计数复原'
    # assert d3 - 2 == @user1.comments_count,'评论的创建人计数复原'                   ### to psvr 原因同上，子评论的作者不应该受到连带
    assert d5 - 1 == @courseware1.comments_count,'被评论物体的计数复原'
    refute @user2.liked_comment_ids.include?(crazy_comment.id),'喜欢人的commentids里面没有了'
  end

end
