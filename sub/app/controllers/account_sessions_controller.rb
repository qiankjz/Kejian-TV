# -*- encoding : utf-8 -*-
class AccountSessionsController < Devise::SessionsController 
  def new
    resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource)) do |format|
      format.html{render "new"}
    end
  end
  def create
    ret = UCenter::User.login(request,{isuid:2,username:params[:user][:email],password:params[:user][:password]})
    status = ret['root']['item'][0].to_i
    suc_flag = false
    if status > 0
      u = nil
      u ||= User.where(uid:status).first
      u ||= User.import_from_dz!(UCenter::User.get_user(request,{username:status,isuid:1}))
      if u
        resource = u
        suc_flag = true
      end
    end
    unless true==suc_flag
      resource = warden.authenticate!(auth_options)
    end
    sign_in_others
    sign_in(resource_name, resource)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    #synlogin = UCenter::User.synlogin(request,{uid:resource.uid})
    #flash[:extra_ucenter_operations] = synlogin.html_safe if synlogin.present?
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
  def destroy
    sign_out_others
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out
    #synlogout = UCenter::User.synlogout(request)
    #flash[:extra_ucenter_operations] = synlogout.html_safe if synlogout.present?
    
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to "/simple/member.php?mod=logging&action=logout&formhash=#{@formhash}" } #redirect_path
      format.all do
        head :no_content
      end
    end
  end
end