class LandingController < ApplicationController
  def index
    @tabs = ["1st", "2nd", "3rd", "4th", "5th", "6th"]
    @active_tab = params[:grade] || @tabs.first

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
