class SearchSuggestionPolicy < ApplicationPolicy

  def nearby?
    if @user.blank?
      false
    else
      (@user.admin? || @user.has_role?('contributor'))
    end
  end

end