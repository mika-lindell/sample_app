require 'spec_helper'

describe MicropostsHelper do
  describe "pluralize micropost" do
    if(Micropost.count > 0)
        it { pluralize(1, "micropost").should == "1 micropost" }
    else
        it { pluralize(0, "micropost").should == "0 microposts" }
    end    
  end 
end