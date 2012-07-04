require 'spec_helper'

describe 'ActionController integration' do

  def hook!
    Storehouse.configure do |c|
      c.reset!
      c.hook_controllers!
    end
  end

  it 'should integrate with ActionController when told to' do
    ActionController::Base.should_receive(:extend).with(Storehouse::Controller).once
    hook!
  end

  context 'assuming AC is hooked' do

    before do
      hook!
      Storehouse.data_store.should_receive(:delete).with('/users').once
    end

    it 'should invoke the data_store when expiring a path' do
      
      ActionController::Base.expire_page('/users')
    end

    it 'should invoke the expiration even if the configuration is told to ignore the path' do
      Storehouse.configure do |c|
        c.except! '/users'
      end
      Storehouse.config.consider_caching?('/users').should be_false
      ActionController::Base.expire_page('/users')
    end

    it 'should invoke the expiration even if the configuration is told to only use other paths' do
      Storehouse.configure do |c|
        c.only! '/jobs'
      end
      Storehouse.config.consider_caching?('/users').should be_false
      ActionController::Base.expire_page('/users')
    end

  end
end