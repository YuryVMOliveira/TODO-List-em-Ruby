json.extract! task, :id, :title, :description, :due_date, :completed
json.url task_url(task, format: :json)
