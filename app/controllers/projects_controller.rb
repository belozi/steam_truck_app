class ProjectsController < ApplicationController
  before_action :signed_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

	def new
		@project = Project.new
	end

	def index
		@projects = Project.all
		@project = current_user.projects.build if signed_in?
	end

	def show 
    @project = Project.find(params[:id])
	end

	def create
  		@project = current_user.projects.build(project_params)
  		if @project.save
  			flash[:success] = "Project created!"
  			redirect_to @project
  		else
  			render 'new'
  		end
  	end 

  	def edit 
  	end

  	def update
    	if @project.update_attributes(project_params)
      		flash[:success] = "Project updated!"
      		redirect_to @project
    	else
      		render 'edit'
    	end
  	end

  	def destroy
    	Project.find(params[:id]).destroy
    	flash[:success] = "Project deleted."
    	redirect_to(index_path)
  	end

  	private

  		def project_params
  		params.require(:project).permit(:project_title,:description, :problem, :solution, 
  										:status, :image) 
  		end

      def correct_user
        @project = current_user.projects.find_by(id: params[:id])
        redirect_to root_url if @project.nil?
      end
end