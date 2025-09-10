class HomeController < ApplicationController
   before_action :redirect_if_logged_in, only: [:index]
def new
end
private

def redirect_if_logged_in
  redirect_to tasks_path, notice: "Você já está logado!" if current_user
end
end

