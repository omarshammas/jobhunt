class FundingRoundsController < ApplicationController
  before_action :set_funding_round, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :require_admin,  except: [:index, :show]


  # GET /funding_rounds
  # GET /funding_rounds.json
  def index
    @funding_rounds = FundingRound.order(announced_on: :desc)
                                  .paginate(page: params[:page])
  end

  # GET /funding_rounds/1
  # GET /funding_rounds/1.json
  def show
  end

  # GET /funding_rounds/new
  def new
    @funding_round = FundingRound.new
  end

  # GET /funding_rounds/1/edit
  def edit
  end

  # POST /funding_rounds
  # POST /funding_rounds.json
  def create
    @funding_round = FundingRound.new(funding_round_params)

    respond_to do |format|
      if @funding_round.save
        format.html { redirect_to @funding_round, notice: 'Funding Round was successfully created.' }
        format.json { render :show, status: :created, location: @funding_round }
      else
        format.html { render :new }
        format.json { render json: @funding_round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /funding_rounds/1
  # PATCH/PUT /funding_rounds/1.json
  def update
    respond_to do |format|
      if @funding_round.update(funding_round_params)
        format.html { redirect_to @funding_round, notice: 'Funding Round was successfully updated.' }
        format.json { render :show, status: :ok, location: @funding_round }
      else
        format.html { render :edit }
        format.json { render json: @funding_round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /funding_rounds/1
  # DELETE /funding_rounds/1.json
  def destroy
    @funding_round.destroy
    respond_to do |format|
      format.html { redirect_to funding_rounds_url, notice: 'Funding Round was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funding_round
      @funding_round = FundingRound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def funding_round_params
      params.require(:funding_round).permit(:company_id, :funding_type, :money_raised_usd, :announced_on, :series)
    end
end
