class ApplicationController < ActionController::Base
  before_action :set_last_dates


  private

  def set_last_dates
    @last_dates = []
    5.times do |i|
      @last_dates << Time.now - i.month
    end
  end
end
