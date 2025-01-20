# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  let(:user) { create(:user, :admin) }

  describe 'GET index' do
    let!(:issues) { create_list(:issue, 2) }

    context 'when the user is not authenticated' do
      before { get :index }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated' do
      before do
        sign_in(user)
        get :index
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end

      it 'assigns @issues' do
        expect(assigns(:issues)).to eq(issues)
      end
    end
  end

  describe 'GET show/:id' do
    let(:issue) { create(:issue) }

    context 'when the user is not authenticated' do
      before { get :show, params: { id: issue.id } }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated' do
      before do
        sign_in(user)
        get :show, params: { id: issue.id }
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end

      it 'assigns @issue' do
        expect(assigns(:issue)).to eq(issue)
      end
    end
  end

  describe 'PATCH assign_to_self' do
    let(:issue) { create(:issue, :without_worker) }

    context "when issue does't have worker" do
      it { expect(issue.worker).to be_nil }
    end

    context 'when the user is not authenticated' do
      before { patch :assign_to_self, params: { id: issue.id } }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated' do
      before do
        sign_in(user)
        patch :assign_to_self, params: { id: issue.id }
      end

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to issues#index page' do
        expect(response).to redirect_to(issues_path)
      end

      it 'outputs a success flash message' do
        expect(flash[:success]).to match(I18n.t('issues.controller.update_success', field: 'Worker'))
      end

      it 'changes the worker for issue' do
        expect(issue.reload.worker).to eq(user)
      end
    end
  end

  describe 'POST create' do
    subject(:create_action) { post :create, params: }

    context 'when the user is not authenticated' do
      let(:params) { { issue: attributes_for(:issue) } }

      before { create_action }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated with valid params' do
      let(:params) { { issue: attributes_for(:issue) } }

      before do
        sign_in(user)
        create_action
      end

      it 'creates a new issue' do
        expect { post :create, params: }.to change(Issue, :count).by(1)
      end

      it 'redirects to the created issue' do
        expect(response).to redirect_to(Issue.last)
      end

      it 'outputs a success flash message' do
        expect(flash[:notice]).to match(I18n.t('issues.controller.created'))
      end

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end
    end

    context 'when the user is authenticated with invalid params' do
      let(:params) { { issue: { title: '', description: '' } } }

      before do
        sign_in(user)
        create_action
      end

      it 'does not create a new issue' do
        expect { create_action }.not_to change(Issue, :count)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'returns a 422' do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH update' do
    subject(:update_action) { patch :update, params: }

    let(:issue) { create(:issue) }

    context 'when the user is not authenticated' do
      let(:params) { { id: issue.id, issue: { title: 'Updated Title' } } }

      before { update_action }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated with valid params' do
      let(:params) { { id: issue.id, issue: { title: 'Updated Title' } } }

      before do
        sign_in(user)
        update_action
      end

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'updates the issue' do
        expect(issue.reload.title).to eq('Updated Title')
      end

      it 'redirects to the updated issue' do
        expect(response).to redirect_to(issue)
      end

      it 'outputs a success flash message' do
        expect(flash[:notice]).to match(I18n.t('issues.controller.updated'))
      end
    end

    context 'when the user is authenticated with invalid params' do
      let(:params) { { id: issue.id, issue: { title: '' } } }

      before do
        sign_in(user)
        update_action
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'returns a 422' do
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'does not update the issue' do
        expect(issue.reload.title).not_to eq('')
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:issue) { create(:issue, creator: user) }

    context 'when the user is not authenticated' do
      before { delete :destroy, params: { id: issue.id } }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated' do
      subject(:delete_action) { delete :destroy, params: { id: issue.id } }

      before { sign_in(user) }

      it 'deletes the issue' do
        expect { delete_action }.to change(Issue, :count).by(-1)
      end

      it 'redirects to issues#index page' do
        delete_action
        expect(response).to redirect_to(issues_path)
      end

      it 'outputs a success flash message' do
        delete_action
        expect(flash[:notice]).to match(I18n.t('issues.controller.deleted'))
      end

      it 'returns a 302' do
        delete_action
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH update_status' do
    subject(:update_status_action) { patch :update_status, params: { id: issue.id, issue: { status: 'closed' } } }

    let(:issue) { create(:issue, creator: user, status: :open) }

    context 'when the user is not authenticated' do
      before { update_status_action }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated' do
      before do
        sign_in(user)
        update_status_action
      end

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'updates the status of the issue' do
        expect(issue.reload.status).to eq('closed')
      end

      it 'redirects to issues#index page' do
        expect(response).to redirect_to(issues_path)
      end

      it 'outputs a success flash message' do
        expect(flash[:success]).to match(I18n.t('issues.controller.update_success', field: 'Status'))
      end
    end
  end

  describe 'PATCH update_priority' do
    subject(:update_priority_action) { patch :update_priority, params: { id: issue.id, issue: { priority: 'high' } } }

    let(:issue) { create(:issue, creator: user, priority: :low) }

    context 'when the user is not authenticated' do
      before { update_priority_action }

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when the user is authenticated' do
      before do
        sign_in(user)
        update_priority_action
      end

      it 'returns a 302' do
        expect(response).to have_http_status(:found)
      end

      it 'updates the priority of the issue' do
        expect(issue.reload.priority).to eq('high')
      end

      it 'redirects to issues#index page' do
        expect(response).to redirect_to(issues_path)
      end

      it 'outputs a success flash message' do
        expect(flash[:success]).to match(I18n.t('issues.controller.update_success', field: 'Priority'))
      end
    end
  end
end
