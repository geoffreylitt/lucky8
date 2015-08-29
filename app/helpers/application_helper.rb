module ApplicationHelper
  # Take a float percentage and format for display
  def percentage(val)
    val.to_i.to_s + "%"
  end
end
