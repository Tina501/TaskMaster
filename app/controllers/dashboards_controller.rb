class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stats, only: [:index]

  def index
    @tasks = current_user.tasks
                        .where(deadline: Time.current.beginning_of_day..Time.current.end_of_day)
                        .order(deadline: :asc)
    @period = params[:period] || "monthly"

    @pending_tasks = current_user.tasks.where(completed: false)
    @completed_tasks = current_user.tasks.where(completed: true)


    respond_to do |format|
      format.html
      format.json do
        render json: chart_data
      end
    end
  end

  private

  def set_stats
    @completed_tasks_count = current_user.tasks.where(completed: true).count || 0
    @total_tasks_count = current_user.tasks.count || 0
  end

  def chart_data
    data = task_completion_data
    {
      labels: generate_labels,
      values: generate_values(data)
    }
  end

  def task_completion_data
    base_query = current_user.tasks.where(completed: true)
    range = time_range

    case @period
    when "daily"
      base_query.where(completed_at: range).group("DATE(completed_at)").count
    when "weekly"
      base_query.where(completed_at: range).group("DATE_TRUNC('week', completed_at)").count
    else
      base_query.where(completed_at: range).group("DATE_TRUNC('month', completed_at)").count
    end
  end

  def time_range
    case @period
    when "daily"
      30.days.ago.beginning_of_day..Time.current.end_of_day
    when "weekly"
      12.weeks.ago.beginning_of_week..Time.current.end_of_week
    else
      12.months.ago.beginning_of_month..Time.current.end_of_month
    end
  end

  def generate_labels
    range = time_range
    dates = case @period
    when "daily"
      (range.begin.to_date..range.end.to_date).to_a
    when "weekly"
      (range.begin.to_date.beginning_of_week..range.end.to_date).step(7).to_a
    else
      (range.begin.to_date.beginning_of_month..range.end.to_date).map(&:beginning_of_month).uniq
    end

    dates.map { |date| format_date(date) }
  end

  def generate_values(data)
    range = time_range
    dates = case @period
    when "daily"
      (range.begin.to_date..range.end.to_date).to_a
    when "weekly"
      (range.begin.to_date.beginning_of_week..range.end.to_date).step(7).to_a
    else
      (range.begin.to_date.beginning_of_month..range.end.to_date).map(&:beginning_of_month).uniq
    end

    dates.map { |date| data[date] || 0 }
  end

  def format_date(date)
    case @period
    when "daily"
      date.strftime("%b %d")
    when "weekly"
      "Week #{date.strftime('%U')}"
    else
      date.strftime("%b %Y")
    end
  end
end
