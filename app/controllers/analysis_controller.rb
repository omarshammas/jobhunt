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
    @companies = Company.includes(:funding_rounds)
                        .order(:name)
                        .where.not('founded_on IS NULL OR is_closed IS TRUE OR is_acquired IS TRUE')
  end

end
