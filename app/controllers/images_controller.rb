class ImagesController < ApplicationController
    before_action :set_recipe

    def index
        @images = @recipe.images
        render 'recipes/images/index'
    end

    # def create
    #     @image = @recipe.photos.build(photo_params)
      
    #     if @photo.save
    #         redirect_to @recipe, notice: 'Photo was successfully uploaded.'
    #     else
    #         render 'recipes/show'
    #     end
    # end
      
    private

    def set_recipe
        @recipe = Recipe.find(params[:recipe_id])
    end
      
    # def image_params
    #     params.require(:image).permit(:path)
    # end

end