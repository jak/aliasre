class HostnamesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :destroy, :generate_new_token]
  before_action :set_hostname, only: [:show, :edit, :update, :destroy, :updateip, :generate_new_token]
  skip_before_action :verify_authenticity_token, if: :api_request?

  def api_request?
    request.format.json?
  end

  # GET /hostnames
  # GET /hostnames.json
  def index
    @hostnames = current_user.hostnames.all
  end

  # GET /hostnames/1
  # GET /hostnames/1.json
  def show
    @hostname.user ||= current_user
    @hostname.save
    session['user_return_to'] = hostname_path(@hostname)
  end

  # GET /hostnames/new
  def new
    @hostname = user_signed_in? ? current_user.hostnames.build : Hostname.new
    @hostname.ipaddress = request.remote_ip
  end

  # GET /hostnames/1/edit
  def edit
  end

  # POST /hostnames
  # POST /hostnames.json
  def create
    @hostname = user_signed_in? ? current_user.hostnames.build(hostname_params) : Hostname.new(hostname_params)

    respond_to do |format|
      if @hostname.save
        format.html { redirect_to @hostname, notice: 'Alias was successfully created.' }
        format.json { render :show, status: :created, location: @hostname }
      else
        format.html { render :new }
        format.json { render json: @hostname.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hostnames/1
  # PATCH/PUT /hostnames/1.json
  def update
    respond_to do |format|
      if @hostname.user != nil and @hostname.user == current_user
        if @hostname.update(hostname_update_params)
          format.html { redirect_to @hostname, notice: 'IP address was successfully updated.' }
          format.json { render :show, status: :ok, location: @hostname }
        else
          format.html { render :edit }
          format.json { render json: @hostname.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, alert: 'That hostname is owned by someone else!' }
        format.json { render json: { message: 'Hostname owned by another user' }, status: 403 }
      end
    end
  end

  # DELETE /hostnames/1
  # DELETE /hostnames/1.json
  def destroy
    @hostname.destroy
    respond_to do |format|
      format.html { redirect_to hostnames_url, notice: 'Alias was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def updateip
    if params[:token] == @hostname.token
      @hostname.ipaddress = params[:ip] || request.remote_ip
      if @hostname.save
        render plain: "OK"
      else
        render plain: "ERROR", status: :unprocessable_entity
      end
    end
  end

  def generate_new_token
    @hostname.generate_token
    respond_to do |format|
      if @hostname.save
        format.html { redirect_to edit_hostname_path(@hostname), notice: 'Token was successfully changed.' }
        format.json { render :show, status: :ok, location: @hostname }
      else
        format.html { render :edit }
        format.json { render json: @hostname.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hostname
      @hostname = Hostname.find_by_name(params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hostname_params
      params.require(:hostname).permit(:name, :ipaddress)
    end

    def hostname_update_params
      params.require(:hostname).permit(:ipaddress)
    end
end
