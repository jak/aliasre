class HostnamesController < ApplicationController
  before_action :set_hostname, only: [:show, :edit, :update, :destroy]

  # GET /hostnames
  # GET /hostnames.json
  def index
    @hostnames = Hostname.all
  end

  # GET /hostnames/1
  # GET /hostnames/1.json
  def show
  end

  # GET /hostnames/new
  def new
    @hostname = Hostname.new
  end

  # GET /hostnames/1/edit
  def edit
  end

  # POST /hostnames
  # POST /hostnames.json
  def create
    @hostname = Hostname.new(hostname_params)

    respond_to do |format|
      if @hostname.save
        format.html { redirect_to @hostname, notice: 'Hostname was successfully created.' }
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
      if @hostname.update(hostname_params)
        format.html { redirect_to @hostname, notice: 'Hostname was successfully updated.' }
        format.json { render :show, status: :ok, location: @hostname }
      else
        format.html { render :edit }
        format.json { render json: @hostname.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hostnames/1
  # DELETE /hostnames/1.json
  def destroy
    @hostname.destroy
    respond_to do |format|
      format.html { redirect_to hostnames_url, notice: 'Hostname was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hostname
      @hostname = Hostname.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hostname_params
      params.require(:hostname).permit(:name, :user_id, :status, :ipaddress)
    end
end
