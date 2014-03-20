require 'spec_helper'

describe SessionsController do

  describe "GET 'creat'" do
    it "returns http success" do
      get 'creat'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

end
