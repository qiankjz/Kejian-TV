# -*- encoding : utf-8 -*-
class AccountPasswordsController < Devise::PasswordsController
  def new
    super
    render "new"
  end
  def create
    self.resource = recoverable = User.find_by_email(resource_params[:email])
    unless recoverable and recoverable.persisted?
      flash[:error] = '此用户不存在' 
      self.send 'new'
      return false
    end
    recoverable.send_reset_password_instructions

    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource) do |format|
        format.html{render "new"}
      end
    end
  end
  def edit
    super
    render "edit"
  end
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    #下面这句话很重要！不要删
    resource.valid?
    #正是因为由上面这句话，下面的判断才管用
    unless resource.errors[:reset_password_token].present? or resource.errors[:password].present? or resource.errors[:password_confirmation].present? 
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource);sign_in_others
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource do |format|
        format.html{render "edit"}
      end
    end
  end
  
end
