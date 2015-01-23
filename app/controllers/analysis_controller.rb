class AnalysisController < ApplicationController
  before_action :set_companies

  def scatter_plot
  end

  def line_chart_time_alive
  end

  def line_chart_since_2005
  end

private

  def set_companies
    set_range
    @companies = Company.includes(:funding_rounds)
                        .order(:name)
                        .where.not('founded_on IS NULL OR is_closed IS TRUE OR is_acquired IS TRUE')
                        .where(total_money_raised_usd: params[:min_range]..params[:max_range])
  end

  def set_range
    params[:min_range] = params[:min_range].try(:to_i) || 20000000
    params[:max_range] = params[:max_range].try(:to_i) || 50000000
  end

end
