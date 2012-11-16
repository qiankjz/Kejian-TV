# -*- encoding : utf-8 -*-
class AskInvite
  include Mongoid::Document
  include BaseModel
  belongs_to :ask
  belongs_to :user
  # 多少人邀请
  field :count, :type => Integer, :default => 0
  # 邀请者
  field :invitor_ids, :type => Array, :default => []
  field :mail_sent, :type => Integer, :default => 0

  # index :ask_id

  scope :unsend, where(:mail_sent => 0, :count.gt => 0)

  def asynchronously_clean_me
    self.user.inc(:invite_count,-1)
    self.invitors.each{|u| u.inc(:invited_count,-1)}
  end
  def invitors
    User.where(:_id.in=>self.invitor_ids)
  end

  def self.insert_log(ask_id, user_id, invitor_id)
    begin
      log = AskLog.new
      log.user_id = invitor_id
      log.target_id = user_id
      log.target_parent_id = ask_id
      log.action = "INVITE_TO_ANSWER"
      if not log.save
        Rails.logger.warn { "*** AskInvite log save failed, because #{log.errors}" }
      end
Rails.logger.warn("suc with #{ask_id} #{user_id} #{invitor_id}")
    rescue Exception => e
      Rails.logger.warn { "#{e}" }
    end
  end

  def self.invite(ask_id,user_id,invitor_id)
    # 插入 Log 和 Notification
    insert_log(ask_id, user_id, invitor_id)

    item = find_or_create_by(:ask_id => ask_id,:user_id => user_id)
if ask = Ask.find(ask_id)
  ask.to_user_ids||=[]
  ask.to_user_ids<<Moped::BSON::ObjectId(user_id)
  ask.save
end
    user = item.user
    return -1 if user.blank?
    item.invitor_ids ||= []
    item.count ||= 0
    return item if item.invitor_ids.include?(invitor_id)
    item.invitor_ids << invitor_id
    item.count += 1

    # 发送邮件
    if(item.mail_sent <= 1)
      if item.user.mail_invite_to_ask
        UserMailer.deliver_delayed(UserMailer.invite_to_answer(item.ask_id, item.user_id, item.invitor_ids))
      end
      item.mail_sent += 1
    end
    item.save
    item
  end

  def self.cancel(id, invitor_id)
    item = find(id)
    ask = item.ask
if ask
  ask.to_user_ids||=[]
  ask.to_user_ids.delete(item.user_id)
  ask.save
end

    return 0 if item.blank?
    item.invitor_ids.delete(invitor_id)
    item.count -= 1
    item.delete if 0==item.count
    item.save
    return ask
  end
end
