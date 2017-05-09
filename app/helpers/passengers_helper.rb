module PassengersHelper
  def selected_input_value(iteration, passenger_value, user_value)
    if iteration > 0
      passenger_value
    else
      passenger_value || user_value
    end
  end

end
