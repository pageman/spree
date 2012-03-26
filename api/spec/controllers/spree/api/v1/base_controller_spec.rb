require 'spec_helper'

describe Spree::Api::V1::BaseController do
  controller(Spree::Api::V1::BaseController) do
    def index
      render :json => { "products" => [] }
    end
  end

  context "cannot make a request to the API" do
    it "without an API key" do
      request.env["X-Spree-Token"] = nil
      api_get :index
      json_response.should == { "error" => "You must specify an API key." }
    end

    it "with an invalid API key" do
      request.env["X-Spree-Token"] = "fake_key"
      request.headers["X-Spree-Token"] = "OMG"
      get :index, :use_route => :spree, :format => :json
      json_response.should == { "error" => "Invalid API key (fake_key) specified." }
    end
  end
end