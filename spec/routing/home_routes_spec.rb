# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PagesController routing', type: :routing do
  it 'routes to pages#home' do
    expect(get: '/').to route_to(controller: 'pages', action: 'home')
  end
end
