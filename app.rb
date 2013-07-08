require 'sinatra'
require 'mongoid'
require 'grape'
require 'grape_entity'

Mongoid.load!("./mongoid.yml")

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String

  attr_accessible :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end
end

module UserHelpers

  def scrub_params(params)
    params.reject!{|k,v| v.blank? }
    params.select{|k,v| User.accessible_attributes.to_a.include? k }
  end

end

module Entities
  class User < Grape::Entity
    expose :id
    expose :first_name
    expose :last_name
    expose :full_name
    expose :email
  end
end

class UserApi < Grape::API
  # configure :production, :development, :staging, :test do
  #   enable :logging
  # end

  rescue_from :all

  format :json

  helpers UserHelpers

  resource :users do

    desc "Return all users."
    get '/' do
      User.limit(20)
    end

    desc "Return a user."
    params do
      requires :id, type: String, desc: "User id."
    end
    route_param :id do
      get do
        user = User.find(params[:id])
        present user, with: Entities::User, type: :full
      end
    end

    desc "Create a user."
    params do
      requires :first_name, type: String, desc: "Your first name."
      requires :last_name, type: String, desc: "Your last name."
      requires :email, type: String, desc: "Your email."
    end
    post do
      User.create!({
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email]
      })
    end

    desc "Update a user."
    put ':id' do
      User.find(params[:id]).update_attributes(scrub_params(params))
    end

    desc "Delete a user."
    params do
      requires :id, type: String, desc: "User ID."
    end
    delete ':id' do
      User.find(params[:id]).destroy
    end

  end
end