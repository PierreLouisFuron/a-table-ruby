class MenusController < ApplicationController

    def index
        session[:menu_count] ||= 7
        @recipes = []
        ids = Recipe.pluck(:id)
        (1..session[:menu_count]).each do 
            @recipes << Recipe.find(ids.sample)
        end
    end

    def update_menu_count
        if params[:menu_action] == 'increase'
            session[:menu_count] ||= 0
            session[:menu_count] += 1
        elsif params[:menu_action] == 'decrease'
            session[:menu_count] = [0, session[:menu_count].to_i - 1].max
        end
        # if params[:menu][:action] == 'increase'
        #     session[:menu_count] ||= 0
        #     session[:menu_count] += 1
        # elsif params[:menu][:action] == 'decrease'
        #     session[:menu_count] = [0, session[:menu_count].to_i - 1].max
        # end
    
        # render json: { menu_count: session[:menu_count] }
      end
end