class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_publisher, only: %i(create)

  def create
    @subscription = Subscription.create(subscriber: current_user, publisher: @publisher)
  end

  private

  def find_publisher
    klass = [User, Community].find {|c| params["#{c.name.underscore}_id"] }
    @publisher = klass.find(params["#{klass.name.underscore}_id"])
  end
end
