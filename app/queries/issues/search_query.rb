# frozen_string_literal: true

module Issues
  class SearchQuery
    def initialize(user:, query: nil, filtering: {}, sorting: {})
      @user = user
      @query = query
      @filtering = filtering
      @sorting = sorting
    end

    def call
      relation = apply_scope
      relation = apply_search(relation)
      relation = apply_filtering(relation)
      relation = apply_sorting(relation)

      paginate_result(relation)
    end

    private

    attr_reader :user, :query, :filtering, :sorting

    ALLOWED_SORT_COLUMNS = %w[created_at priority status title].freeze
    ALLOWED_SORT_DIRECTIONS = %w[asc desc].freeze

    def apply_scope
      @user.resident? ? @user.opened_issues : Issue.includes(:creator, :worker)
    end

    def apply_search(relation)
      return relation if @query.blank?

      relation.left_joins(:creator, :worker).where(
        'issues.title ILIKE :query OR users.email ILIKE :query OR workers_issues.email ILIKE :query',
        query: "%#{@query}%"
      )
    end

    def apply_filtering(relation)
      relation = relation.where(status: @filtering[:status]) if @filtering[:status].present?
      relation = relation.where(priority: @filtering[:priority]) if @filtering[:priority].present?
      relation
    end

    def apply_sorting(relation)
      sort_column = ALLOWED_SORT_COLUMNS.include?(@sorting[:column]) ? @sorting[:column] : 'created_at'
      sort_direction = ALLOWED_SORT_DIRECTIONS.include?(@sorting[:direction]) ? @sorting[:direction] : 'desc'

      relation.order(sort_column => sort_direction)
    end

    def paginate_result(relation)
      Kaminari.paginate_array(relation)
    end
  end
end
