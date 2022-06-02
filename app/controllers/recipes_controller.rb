class RecipesController < ApplicationController

    def index
        user = User.find_by(id: session[:user_id])
        if user
            recipes = user.recipes
            render json: recipes, include: [:user]
        else
            render json: {errors: ["You must be logged in to view your recipes."]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe = user.recipes.create(recipe_params)
            if recipe.valid?
                render json: recipe, include: [:user], status: :created
            else
                render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["You must be logged in to create a recipe."]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

end
