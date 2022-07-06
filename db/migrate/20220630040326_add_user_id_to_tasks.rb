class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  #マイグレーションのバージョンを下げるときのためにupとdownに分けて書く
  #changeにまとめると1対多の関係の行き場がなくなってエラー
  def up
    execute 'DELETE FROM tasks'
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, index: true
  end
end
