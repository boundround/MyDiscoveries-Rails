class SearchSuggestionPolicy < ApplicationPolicy

  def nearby?
    if @user.blank?
      false
    else
      @user.admin?
    end
  end

end
