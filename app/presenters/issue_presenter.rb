# frozen_string_literal: true

class IssuePresenter < SimpleDelegator
  def display_image_path
    image.attached? ? image.variant(:large) : 'empty_issue_image.png'
  end

  def name_of(user:)
    return 'Not Assigned' unless user

    "#{user.profile.first_name} #{user.profile.last_name} (#{user.email})"
  end

  def created_time
    created_at.strftime('%Y-%m-%d %H:%M')
  end
end
