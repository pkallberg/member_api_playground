require 'sinatra'
require 'mongoid'
require 'grape'
require 'grape_entity'

Mongoid.load!("./mongoid.yml")

class Member
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
end

class MemberApi < Grape::API
  # configure :production, :development, :staging, :test do
  #   enable :logging
  # end

  rescue_from :all

  format :json

  module Entities
    class Member < Grape::Entity
      expose :id
      expose :first_name
      expose :last_name
    end
  end

  resource :members do

    desc "Return all members."
      get '/' do
        Member.limit(20)
      end

    desc "Return a member."
      params do
        requires :id, type: String, desc: "Member id."
      end
      route_param :id do
        get do
          member = Member.find(params[:id])
          present member, with: Entities::Member, type: :full
        end
      end
    end

    desc "Create a member."
      params do
        requires :first_name, type: String, desc: "Your first name."
        requires :last_name, type: String, desc: "Your last name."
      end
      post do
        Member.create!({
          first_name: params[:first_name],
          last_name: params[:last_name]
        })
      end

  get '/' do
    'Hello from the MemberApi Server'
  end

end