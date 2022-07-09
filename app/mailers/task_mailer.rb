class TaskMailer < ApplicationMailer
  def creation_email(task)
    @task = task # メール本文で使用するためインスタンス変数に代入
    mail(
      subject: 'タスク作成完了メール',
      to: 'user@example.com',
      from: 'taskleaf@example.com'
    )
  end
end
