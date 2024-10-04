class ForumsController < ApplicationController
  def new
    @forum = Forum.new
  end

  def index
  end
end
