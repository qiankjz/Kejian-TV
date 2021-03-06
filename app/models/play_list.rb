# -*- encoding : utf-8 -*-
class PlayList
  include Mongoid::Document
  include Mongoid::Timestamps
  include Redis::Search
  include BaseModel
  @after_soft_delete = proc{
    redis_search_index_destroy
    redis_search_psvr_was_delete!
  }
  # sort by this
  field :score,:type=>Integer,:default=>0  
  field :status
  scope :normal, where(:status => 0 )
  # 0 normal
  # 1 cw.ktvid.blank
  # 2 less than two coursewares
  # 3 inner cw is abnormal or transcoding
  scope :undestroyable, where(:undestroyable=>true)
  scope :destroyable, where(:undestroyable.ne=>true)
  
  field :privacy, :type=>Integer, :default=>0
  scope :no_privacy, where(:privacy => 0)
  PRIVACY_TYPE = {
    0 => '公开',    # 列表里面有
    1 => '不公开',   # 列表里没有，但是可以通过链接打开、分享
    2 => '私有'      # 私有就是私有
  }
  PRIVACY_EN = {
    'public' => '公开',    # 列表里面有
    'unlisted' => '不公开',   # 列表里没有，但是可以通过链接打开、分享
    'private' => '私有'      # 私有就是私有
  }
  field :undestroyable,:type=>Boolean,:default=>false
  
  field :is_history,:type=>Boolean,:default=>false
  scope :not_history, where(:is_history => false)
  
  field :subsite
  field :uid
  field :author # slug
  field :ktvid
  field :school_name
  field :school_id
  field :user_name
  field :user_id
  field :topic
  field :topics
  field :topic_id
  field :course_fids,:type=>Array,:default=>[]
  field :teacher
  field :teacher_typeid
  field :title
  validates :title,:presence =>true
  field :title_en
  field :coursewares_count
  field :views_count,:type=>Integer,:default=>0
  field :ibeike_course_id
  field :sort1

  field :content,:type=>Array,:default=>[]
  field :content_delete_cache,:default=>nil
  field :annotation,:type=>Array,:default=>[]
  field :page_mark,:type=>Array,:default=>[]
  field :history_time_mark,:type=>Array,:default=>[]
  
  field :playlist_thumbnail_kejian_id
  field :content_total_pages,:type=>Integer,:default=>0
  field :content_memos,:type=>Hash,:default=>{}
  field :content_ktvids,:type=>Array,:default=>[]
  field :desc # 备注
  field :tid
  field :playlist_allow_embedding,:type=>Boolean,:default => true
  field :playlist_allow_ratings,:type=>Boolean,:default => true
  field :vote_up,:type=>Integer,:default=>0
  field :vote_down,:type=>Integer,:default=>0
  field :playlist_enable_grid_view,:type=>Boolean,:default => false
  field :disliked_user_ids, :type => Array, :default => []
  field :liked_user_ids, :type => Array, :default => []

  
  # index :content
  scope :series_by_cw, proc{|cw_id|CoursewareSeries.where(:content=>cw_id)}
  def self.run_later
    PlayList.all.map{|x| x.ua(:title_en,Pinyin.t(x.title))}
    PlayList.all.each do |x| 
        x.content.each do |id|
          cw=Courseware.find(id)
          x.content_total_pages = 0
          x.content_total_pages += cw.slides_count
        end
        x.save(:validate => false)
    end
  end
  def user
    @user = nil if self.user_id_changed?
    @user ||= User.where(id:self.user_id).first
  end
  def disliked_by_user(user)
    self.disliked_user_ids ||=[]
    if user.thanked_play_list_ids.include?(self.id)
      self.liked_user_ids.delete(user.id)
      user.thanked_play_list_ids.delete(self.id)
      self.inc(:vote_up,-1)
      self.user.inc(:thanked_count,-1)
      user.thank_count -= 1
      user.save(:validate=>false)
    end
    if self.disliked_user_ids.index(user.id)
      self.disliked_user_ids.delete(user.id)
      self.inc(:vote_down,-1)
      self.save(:validate=>false)
      self.user.inc(:disliked_count,-1)
      user.inc(:dislike_count,-1)
      return false
    end
    self.disliked_user_ids << user.id
    self.inc(:vote_down,1)
    self.save(:validate=>false)
    self.user.inc(:disliked_count,1)
    user.inc(:dislike_count,1)
    return true
  end
  
  def self.locate(user_id,title)
    self.find_or_create_by(user_id:user_id,title:title)
  end
  
  ####
  # => 注意：在User.rb里面有一个  after_create :create_playlists_for_user
  # => def create_playlists_for_user
  # => end
  # => 需要修改
  ###
  def self.create_defaults_for_all_users
    User.all.each do |u|
      x=PlayList.find_or_create_by(user_id:u.id,title:'收藏')
      y=PlayList.find_or_create_by(user_id:u.id,title:'稍后阅读')
      z=PlayList.find_or_create_by(user_id:u.id,title:'历史记录')
      z.update_attribute(:is_history,true)
      z.update_attribute(:privacy,2)            #private##需要好友可见
      g=PlayList.find_or_create_by(user_id:u.id,title:'已购买')
      g.update_attribute(:privacy,2)            #private
      g.update_attribute(:is_history,true)
      x.update_attribute(:undestroyable,true)
      y.update_attribute(:undestroyable,true)
      z.update_attribute(:undestroyable,true)
      g.update_attribute(:undestroyable,true)
    end
  end
  def self.on_off_history(user_id,op='off')
    if op == 'off'
      User.find(user_id).ua(:mark_history,false)
    elsif op == 'on'
      User.find(user_id).ua(:mark_history,true)
    end
  end
  def self.clear_history(user_id)
    pl = PlayList.where(:user_id=>user_id,:undestroyable=>true,:title=>'历史记录').first
    pl.content = []
    pl.page_mark = []
    pl.history_time_mark = []
    if pl.save(:validate=>false)
      return true
    else
      return false
    end
  end
  def self.remove_one_history(user_id,cwid,time)
    return false if !Moped::BSON::ObjectId.legal?(cwid)
    pl = PlayList.where(:user_id=>user_id,:undestroyable=>true,:title=>'历史记录').first
    cw = Courseware.find(cwid)
    return false if cw.nil?
    if pl.content.include?(cw.id) and pl.history_time_mark.include?(time)
      index = pl.history_time_mark.index(time)
      pl.content.delete_at(index)
      pl.annotation.delete_at(index)
      pl.page_mark.delete_at(index)
      pl.history_time_mark.delete_at(index)
      pl.save(:validate=>false)
      return true
    end
    return false
  end
  def self.add_to_history(user_id,cwid,page=nil)
    pl = PlayList.where(:user_id=>user_id,:undestroyable=>true,:title=>'历史记录').first
    return false if !User.find(user_id).mark_history
    return false if !Moped::BSON::ObjectId.legal?(cwid)
    cw = Courseware.find(cwid)
    return false if cw.nil?
    if pl.content.include?(cw.id)
      index = pl.content.rindex(cw.id)
      gap = Time.now.to_i - pl.history_time_mark[index]
      if gap < 1.week
        if page.nil?
          page_mark = pl.page_mark[index]
        else
          page_mark = page
        end
        pl.history_time_mark.delete_at(index)
        pl.page_mark.delete_at(index)
        pl.content.delete_at(index)
        # query = {:user_id=>user_id,:undestroyable=>true,:title=>'历史记录'}
        # pull = {content:cw.id,page_mark:pl.page_mark[index],history_time_mark:pl.history_time_mark[index]}
        # pl.collection.find_and_modify(query:query,update:{"$pull"=>pull},new:true)
        # push = {content:cw.id,page_mark:page_mark,history_time_mark:Time.now.to_i}
        # pl.find_and_modify(update:{"$push"=>push},new:true)
        pl.content << cw.id
        pl.annotation << ''
        pl.page_mark << page_mark
        pl.history_time_mark << Time.now.to_i
        pl.save
        return true
      end
    end
    if page.nil?
      page_mark = pl.page_mark[index]
    else
      page_mark = page
    end
    # query = {:user_id=>user_id,:undestroyable=>true,:title=>'历史记录'}
    # push = {content:cw.id,page_mark:page_mark,history_time_mark:Time.now.to_i}
    # pl.find_and_modify(update:{"$push"=>push},new:true)
    pl.content << cw.id
    pl.annotation << ''
    pl.page_mark << page_mark
    pl.history_time_mark << Time.now.to_i
    pl.save
    return true
  end
  
  def self.add_to_read_later(user_id,cwid,title='稍后阅读')
      return false if !Moped::BSON::ObjectId.legal?(cwid)
      cw=Courseware.find(cwid)
      return false if cw.nil?
      pl = PlayList.where(:user_id=>user_id,:undestroyable=>true,:title=>title).first
      return false if pl.content.include?(cw.id)
      pl.content << cw.id
      pl.annotation << ''
      if pl.save(:validate=>false)
        return pl.id
      else
        return false
      end
  end
  def self.remove_from_read_later(user_id,cwid,title='稍后阅读')
      return false if !Moped::BSON::ObjectId.legal?(cwid)
      cw = Courseware.find(cwid)
      return false if cw.nil?
      pl = PlayList.where(:user_id=>user_id,:undestroyable=>true,:title=>title).first
      return false if !pl.content.include?(cw.id)
      pl.annotation.delete_at(pl.content.index(cw.id))
      pl.content.delete(cw.id)
      if pl.save(:validate=>false)
        return pl.id
      else
        return false
      end
  end
  def self.exist_in_read_later?(user_id,cwid)
      return false if !Moped::BSON::ObjectId.legal?(cwid)
      pl = PlayList.where(:user_id=>user_id,:undestroyable=>true,:title=>'稍后阅读').first
      return true if pl.content.include?(Courseware.find(cwid).id)
      return false
  end
  def add_one_thing(thing,ding=false)
    return false if !Moped::BSON::ObjectId.legal?(thing.to_s)
    cw = Courseware.find(thing)
    return false if cw.nil?
    return false if self.content.include?(cw.id)
    if ding
      self.content.unshift(cw.id)
      self.annotation.unshift('')
    else
      self.content<<cw.id
      self.annotation << ''
    end
    self.save(:validate=>false)
  end
  
  def thread_inst
    PreForumThread.find_by_tid(self.tid)
  end

  before_save :thumb_ktvids_op
  def thumb_ktvids_op
    if self.undestroyable == true
        if self.title_changed? or self.desc_changed? or self.privacy_changed? or self.is_history_changed? or self.user_id_changed?
             return false
        end
    end
    self.title_en = Pinyin.t self.title
    self.status=0
    self.coursewares_count = self.content.nil? ? 0 : self.content.size
    harr=[]
    arr=[]
    content = []
    added = []
    deled = []
    if self.content_changed? 
      self.content_total_pages = 0 
      added = self.content - self.content_was.to_a
      deled = self.content_was.to_a - self.content
    end
    if self.content.present?
      self.content.each_with_index do |id,index|
        cw=Courseware.where(id:id).first
        if cw.nil?
          next
        end
        self.status=3 if cw.status != 0
        self.status=1 if cw.ktvid.blank?
        ### Liber TODO raise exception and log 
        if self.content_changed? 
          self.content_total_pages += cw.slides_count
          if added.include?(cw.id) 
            ci = cw.course_ins
            di = cw.department_ins
            ci.inc(:play_lists_count,1) if ci
            di.inc(:play_lists_count,1) if di
          end
          deled.each do |d|
            dcw = Courseware.where(id:d).first
            if dcw
              ci = dcw.course_ins
              di = dcw.department_ins 
              ci.inc(:play_lists_count,-1) if ci
              di.inc(:play_lists_count,-1) if di
            end
          end
        end
        harr << cw.ktvid
        arr << cw.course_fid
        content[index] = cw.id
      end
    end
    self.content = content.compact
    self.annotation = self.annotation.to_a
    self.status=2 if self.content.nil? or self.content.count < 2
    self.content_ktvids=harr
    self.course_fids=arr.uniq.compact
    if self.undestroyable == true
      self.status = 0
    end
  end
  def asynchronously_clean_me
    bad_ids = [self.id]
    self.disliked_user_ids.each do |uid|
      u = User.where(id:uid).first
      u.inc(:dislike_count,-1) if u
      su = self.user
      su.inc(:disliked_count,-1) if su
    end
    self.liked_user_ids.each do |uid|
      u = User.where(id:uid).first
      u.inc(:thank_count,-1) if u
      su = self.user
      su.inc(:thanked_count,-1) if su
    end
    Util.bad_id_out_of!(User,:thanked_play_list_ids,bad_ids)
    thanked = false
  end
  def coursewares(alt=nil)
    alt||=self.content
    return Courseware.eager_load(self.content)
  end
  def courseware_titles
    self.coursewares.collect(&:title)
  end
  def courseware_titles_changed?
    self.content_changed?
  end
  def courseware_titles_was
    self.coursewares(self.content_was).collect &:title
  end
  def redis_search_alias(alt=nil)
    alt=self.courseware_titles if alt.nil?
    alt.map { |e|  e if e.present? }.compact.join(', ')
  end
  def redis_search_alias_changed?
    self.courseware_titles_changed?
  end
  def redis_search_alias_was
    self.redis_search_alias(courseware_titles_was)
  end
  redis_search_index(:title_field => :title,
                     :alias_field => :redis_search_alias,
                     :score_field => :score,
                     :ext_fields => [:coursewares_count,:courseware_titles],
                     :prefix_index_enable => false,
                    )
  alias_method :redis_search_index_create_before_psvr,:redis_search_index_create
  alias_method :redis_search_index_need_reindex_before_psvr,:redis_search_index_need_reindex
  def redis_search_psvr_okay?
    !self.soft_deleted? and !self.undestroyable and 0==self.status and 0==self.privacy and self.title.present? and self.redis_search_alias.present?
  end
  def redis_search_index_need_reindex
    if !redis_search_psvr_okay?
      # p "will delete:#{!self.soft_deleted?} and #{!self.undestroyable} and #{0==self.status} and #{0==self.privacy} and #{self.title.present?} and #{self.redis_search_alias.present?}"
      redis_search_index_destroy
      redis_search_psvr_was_delete!
      return false
    else
      return (self.deleted_changed? || self.undestroyable_changed? || self.status_changed? || self.privacy_changed? || self.redis_search_index_need_reindex_before_psvr)      
    end
  end
  def redis_search_index_create
    # p 'will create'
    self.redis_search_index_create_before_psvr if self.redis_search_psvr_okay?
  end
end

