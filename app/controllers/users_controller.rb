class UsersController < ApplicationController

  before_filter :ensure_that_logged_in, :except => [ :index, :show, :new, :create ]
  before_filter :ensure_that_not_logged_in, :only => [ :new ]
  before_filter :ensure_that_admin, :only => [ :destroy ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new

    @user = User.new
    @teams = Team.all

  end

  # GET /users/1/edit
  def edit

    @teams = Team.all

  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)
    @teams = Team.all

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_path) }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    @teams = Team.all

    respond_to do |format|

      if (currently_logged_in?(@user) or current_user.admin?) and @user.update(user_params)
        format.html { redirect_to(users_path) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end

    end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :team_id)
    end

end
