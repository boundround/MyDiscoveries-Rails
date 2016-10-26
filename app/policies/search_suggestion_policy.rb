class SearchSuggestionPolicy < ApplicationPolicy

  def nearby?
    if @user.blank?
      false
    else
      (@user.admin? || @user.roles.map(&:name).include?('contributor'))
    end
  end

end