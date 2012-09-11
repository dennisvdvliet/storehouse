class UsersController < ApplicationController

  caches_page :show, :account, :root, :if => :should_cache?
  caches_page :index, :expires_in => 10.minutes
  caches_page :settings, :storehouse => false
  cache_sweeper :user_sweeper, :only => [ :touch ]
  
  def index
    @users = User.all
  end

  def root
    render :text => request.query_string, :layout => false
  end

  def show
    @user = User.find(params[:id])
  end

  def account
    @user = User.find(params[:id])
  end

  def settings
    @user = User.find(params[:id])
    render :text => 'settings'
  end

  def touch
    @user = User.find(params[:id])
    @user.update_attributes(:updated_at => Time.now)
    redirect_to :action => :show
  end

  protected

  def should_cache?
    request.query_string.blank?
  end

end