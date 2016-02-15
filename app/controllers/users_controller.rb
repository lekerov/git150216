class UsersController < ApplicationController

    before_action :signed_in_user, only: [:edit, :update]
    before_action :correct_user, only: [:edit, :update]
    
    def index
    @users = User.paginate(page: params[:page])
    end
    
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save 
            sign_in @user
            flash[:success] = "Спасибо за регистрацию!"
            redirect_to @user
        else
            render "new"
        end
    end
    
    def show
        @user = User.find(params[:id])
    end
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            flash[:success] = "Данные успешно обновлены"
            redirect_to user
        else
        render 'edit'
        end
    end
    
    
    
    private
    
    def user_params
        params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end
    
    def sign_in_user
        unless signed_in?
        flash[:danger] = "Необходимо авторизоваться!"
        
        def store_location
            session[:return_to] = request.url if request.get?
        end
        
        redirect_to login_path
        end
    end
    
    def signed_in_user
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    
    def correct_user
        @user = User.find(params[:id])
        flash[:danger] = "Доступ запрещен!"
        redirect_to(root_url) unless current_user?(@user)
    end
    
   

end
