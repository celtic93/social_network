class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_publisher, only: %i(create)
  before_action :find_subscription, only: %i(destroy)

  def create
    @subscription = Subscription.create(subscriber: current_user, publisher: @publisher)
  end

  def destroy
    if @subscription
      @subscription.destroy
    else
      redirect_to root_path, alert: 'You can not do this'
    end
  end

  private

  def find_publisher
    klass = [User, Community].find {|c| params["#{c.name.underscore}_id"] }
    @publisher = klass.find(params["#{klass.name.underscore}_id"])
  end

  def find_subscription
    klass = [User, Community].find {|c| c.name == params[:publisher_type] }
    @publisher = klass.find(params[:id])
    @subscription = current_user.subscriptions.find_by(publisher: @publisher)
  end
end
