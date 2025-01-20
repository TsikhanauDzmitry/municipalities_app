# frozen_string_literal: true

module IssuesHelper
  def issue_attribute_form(issue, attribute, collection, path)
    return issue.public_send(attribute).humanize if current_user.resident?

    form_with(model: issue, url: path, method: :patch, local: true) do |f|
      f.select attribute,
               collection.keys.map { |key| [key.humanize, key] },
               { selected: issue.public_send(attribute) },
               class: 'form-select',
               onchange: 'this.form.submit()'
    end
  end
end
