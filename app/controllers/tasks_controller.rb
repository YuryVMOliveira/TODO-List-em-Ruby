class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :require_login
  before_action :set_list, if: -> { params[:list_id].present? }

  # GET /tasks or /tasks.json
  def index
    redirect_to lists_path
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    respond_to do |format|
      format.html { render partial: 'show_details' }
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.list = @list if @list
  end

  # GET /tasks/1/edit
  def edit
    respond_to do |format|
      format.html { render partial: 'edit_form' }
      format.json { render json: @task }
    end
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    @task.completed = false # Garantir que seja false por padrão
    
    # Se list_id foi passado, encontrar a lista
    if task_params[:list_id].present?
      @task.list = current_user.lists.find(task_params[:list_id])
    end
    
    respond_to do |format|
      if @task.save
        redirect_path = @task.list ? list_path(@task.list) : tasks_path
        format.html { redirect_to redirect_path, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        Rails.logger.error "Task creation failed: #{@task.errors.full_messages}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        redirect_path = @task.list ? list_path(@task.list) : tasks_path
        format.html { redirect_to redirect_path, notice: "Task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    list = @task.list
    @task.destroy!

    respond_to do |format|
      redirect_path = list ? list_path(list) : tasks_path
      format.html { redirect_to redirect_path, notice: "Task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def set_list
      @list = current_user.lists.find(params[:list_id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :completed, :list_id)
    end

    def require_login
      redirect_to new_session_path, alert: "Please login to access your tasks." unless current_user
    end
end
