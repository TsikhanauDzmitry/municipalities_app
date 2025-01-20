# frozen_string_literal: true

RSpec.describe 'Issues routes path', type: :routing do
  let(:issue) { create(:issue) }

  it 'routes root path to Issues#index' do
    expect(get: '/issues').to route_to(controller: 'issues', action: 'index')
  end

  it 'routes issue path to Issues#show' do
    expect(get: "/issues/#{issue.id}").to route_to(controller: 'issues', action: 'show', id: issue.id.to_s)
  end

  it 'routes edit_issue path to Issues#update' do
    expect(patch: "/issues/#{issue.id}").to route_to(controller: 'issues', action: 'update', id: issue.id.to_s)
  end

  it 'routes new_issue path to Issues#create' do
    expect(post: '/issues').to route_to(controller: 'issues', action: 'create')
  end

  it 'routes destroy_issue path to Issues#destroy' do
    expect(delete: "/issues/#{issue.id}").to route_to(controller: 'issues', action: 'destroy', id: issue.id.to_s)
  end

  it 'routes issue_assign_to_self to Issues#assign_to_self' do
    expect(patch: "/issues/#{issue.id}/assign_to_self").to route_to(controller: 'issues',
                                                                    action: 'assign_to_self',
                                                                    id: issue.id.to_s)
  end

  it 'routes issue_update_status to Issues#update_status' do
    expect(patch: "/issues/#{issue.id}/update_status").to route_to(controller: 'issues',
                                                                   action: 'update_status',
                                                                   id: issue.id.to_s)
  end

  it 'routes issue_update_priority to Issues#update_priority' do
    expect(patch: "/issues/#{issue.id}/update_priority").to route_to(controller: 'issues',
                                                                     action: 'update_priority',
                                                                     id: issue.id.to_s)
  end
end
