# frozen_string_literal: true

class IssuesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @issues = Issues::SearchService.new(
      user: current_user,
      query: params[:query],
      filtering: { status: params[:status], priority: params[:priority] },
      sorting: { column: params[:sort], direction: params[:direction] }
    ).call.page(params[:page]).per(params[:per_page])
  end

  def show; end

  def new; end

  def edit; end

  def create
    @issue = Issue.new(issue_params.merge(created_by: current_user.id))
    return render :new, status: :unprocessable_entity unless @issue.save

    redirect_to @issue, notice: I18n.t('issues.controller.created')
  end

  def update
    permitted_params = current_user.resident? ? issue_params : issue_params_admin_or_employee
    return render :edit, status: :unprocessable_entity unless @issue.update(permitted_params)

    redirect_to @issue, notice: I18n.t('issues.controller.updated')
  end

  def destroy
    @issue.destroy

    redirect_to issues_path, notice: I18n.t('issues.controller.deleted')
  end

  def assign_to_self
    result = Issues::UpdateService.new(issue: @issue, field_name: :worker, data: current_user, current_user:).call

    redirect_to issues_path, flash: { result[:flash][:type] => result[:flash][:message] }
  end

  def update_status
    result = Issues::UpdateService.new(
      issue: @issue,
      field_name: :status,
      data: params[:issue][:status],
      current_user:
    ).call

    redirect_to issues_path, flash: { result[:flash][:type] => result[:flash][:message] }
  end

  def update_priority
    result = Issues::UpdateService.new(
      issue: @issue,
      field_name: :priority,
      data: params[:issue][:priority],
      current_user:
    ).call

    redirect_to issues_path, flash: { result[:flash][:type] => result[:flash][:message] }
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :image)
  end

  def issue_params_admin_or_employee
    params.require(:issue).permit(:title, :description, :image, :status, :priority, :worker_id)
  end
end
