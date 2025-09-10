class ListsController < ApplicationController
  before_action :require_login
  before_action :set_lists
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to list_path(@lists.first) if @lists.any?
  end

  def show
    @my_tasks = @list.tasks.where(completed: [false, nil]).order(due_date: :asc)
    @concluded_tasks = @list.tasks.where(completed: true).order(due_date: :desc)
  end

  def edit
  end

  def update
    if @list.update(list_params)
      redirect_to lists_path, notice: "List updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_path, notice: "List deleted successfully!"
  end

  def create
    @list = current_user.lists.build(list_params)
    
    if @list.save
      redirect_to lists_path, notice: "List created successfully!"
    else
      flash.now[:alert] = "Error creating list. Check the data."
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_lists
    @lists = current_user.lists
  end

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name)
  end

  def require_login
    redirect_to new_session_path, alert: "Please login to access your lists." unless current_user
  end
end
