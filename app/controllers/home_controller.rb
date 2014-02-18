class HomeController < ApplicationController

  def get_states
    @states = State.all
    render :json => @states.map{|p| {'value'=> p.id, 'text'=> p.name}}
  end

  def get_gender
    genders = [{'value'=> MALE, 'text'=> 'Male'}]
    genders << {'value'=> FEMALE, 'text'=> 'Female'}
    render :json => genders
  end
  
  def index
  
  end
end
