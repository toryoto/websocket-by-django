class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    #@tasks = current_user.tasks.recent
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]) # recentはスコープ

    respond_to do |format|
      format.html
      format.csv {send_data @tasks.generate_csv, file_name: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"}
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  def import
    file = params[:file]
    if file == nil
      redirect_to tasks_url, notice: "CSVファイルを選択してください"
    elsif File.extname(file) != ".csv"
      redirect_to tasks_url, notice: "CSV形式のファイルを選択してください"
    else
      CSV.foreach(file.path, headers: true) do |row| # foreach : 第一引数で指定されたファイルを1行ずつ実行
        task = current_user.tasks.new
        task.attributes = row.to_hash.slice(*csv_attributes) # 列をハッシュに
        task.save!
      end
      redirect_to tasks_url, notice: "タスクを追加しました"
    end
  end
  

  private
  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def csv_attributes # csvに度の属性を度の順番で出力するか
    ["name", "description", "created_at", "updated_at"]
  end

end
