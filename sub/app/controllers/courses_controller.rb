# -*- encoding : utf-8 -*-
class CoursesController < ApplicationController
  before_filter :find_item,:only => [:show,:follow,:unfollow]
  def index
    @seo[:title]='课程目录'
    @courses = Course
    @courses = @courses.where(:years=>params[:years].to_i) if params[:years].present?
    @courses = @courses.desc('coursewares_count')
    @courses = @courses.paginate(:page => params[:page], :per_page => 100)
    @courses_now_count = Course.where(:years=>20122).count
  end
  def follow
    current_user.follow_course(@course)
    render :text => "1"
  end
  def unfollow
    current_user.unfollow_course(@course)
    render :text => "1"
  end

  def show
    @seo[:title]=@course.name
    render :layout=>false
  end
protected
  def find_item
    @course = Course.where(:fid => params[:id].to_i).first
    @course ||= Course.where(:_id => params[:id]).first
    if @course.nil?
      render_404
      return false
    end
  end
end
