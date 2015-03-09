class FunFactsUsersController < ApplicationController

  def create
    @fun_facts_user = FunFactsUser.new(fun_facts_user_params)

    if @fun_facts_user.save
      render nothing: true
    end
  end

  def destroy
    @fun_facts_user = FunFactsUser.find_by(fun_fact_id: params["fun_facts_user"]["fun_fact_id"], user_id: params["fun_facts_user"]["user_id"])
    @fun_facts_user.destroy
    render nothing: true
  end

  private
    def fun_facts_user_params
      params.require(:fun_facts_user).permit(:fun_fact_id, :user_id)
    end

end
