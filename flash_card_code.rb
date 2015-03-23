# Imagine were in users/index.html.haml

- @post.users.where("age > 23").each do |person|
  = person.name


# How to put Sinatra app into a Rails app

class HelloApp < Sinatra::Base
  get '/' do
    "Hello World!"
  end
end

Rails.application.routes.draw do
  mount HelloApp, at: '/hello'
end

auction = Auction.find(params[:auction_id])
bid = auction.bids.find(params[:id])

# Making a good looking update
class ProjectController < ApplicationController
  def update
    project = Project.find(params[:id])
    if project.update(params[:project])
      redirect_to project
    else
      render 'edit'
    end
  end
end

