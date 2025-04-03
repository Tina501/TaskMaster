module ApplicationHelper
  include Pagy::Frontend

  def task_priority_class(priority)
    case priority
    when 1
      'bg-blue-100 text-blue-800'
    when 2
      'bg-yellow-100 text-yellow-800'
    when 3
      'bg-red-100 text-red-800'
    end
  end

  def task_priority_text(priority)
    case priority
    when 1
      'Low Priority'
    when 2
      'Medium Priority'
    when 3
      'High Priority'
    end
  end
end
