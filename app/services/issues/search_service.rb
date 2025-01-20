# frozen_string_literal: true

module Issues
  class SearchService
    def initialize(user:, query: nil, filtering: {}, sorting: {})
      @user = user
      @query = query
      @filtering = filtering
      @sorting = sorting
    end

    def call
      relation = scope
      relation = search(relation)
      relation = filter(relation)
      relation = sort(relation)

      paginate_result(relation)
    end

    private

    attr_reader :query, :filtering, :sorting, :user

    ALLOWED_SORT_COLUMNS = %w[created_at priority status title].freeze
    ALLOWED_SORT_DIRECTIONS = %w[asc desc].freeze

    def scope
      @user.resident? ? @user.opened_issues : Issue.includes(:creator, :worker)
    end

    def search(relation)
      return relation if @query.blank?

      relation.left_joins(:creator, :worker).where(
        'issues.title ILIKE :query OR users.email ILIKE :query OR workers_issues.email ILIKE :query',
        query: "%#{@query}%"
      )
    end

    def filter(relation)
      relation = relation.where(status: @filtering[:status]) if @filtering[:status].present?
      relation = relation.where(priority: @filtering[:priority]) if @filtering[:priority].present?

      relation
    end

    def sort(relation)
      sort_column = ALLOWED_SORT_COLUMNS.include?(@sorting[:column]) ? @sorting[:column] : 'created_at'
      direction = ALLOWED_SORT_DIRECTIONS.include?(@sorting[:direction]) ? @sorting[:direction] : 'asc'

      relation.order(sort_column => direction)
    end

    def paginate_result(relation)
      Kaminari.paginate_array(relation)
    end
  end
end
