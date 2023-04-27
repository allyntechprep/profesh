class ApplicationController < ActionController::Base
  def index
    render ({ :template => "index/index.html.erb" })
  end
end
