class Task < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def self.csv_attributes # csvに度の属性を度の順番で出力するか
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes # CSVの1行目としてヘッダを出力
      all.each do |task| # allメソッドで全レコード取得
        csv << csv_attributes.map{|attr| task.send(attr)} # 列名ごとに取り出して格納
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row| # foreach : 第一引数で指定されたファイルを1行ずつ実行
      task = find_by(id: row["id"]) || new # 一行ごとにTaskインスタンスを生成
      task.attributes = row.to_hash.slice(*csv_attributes) # 列をハッシュに
      task.save!
    end
  end

  def self.ransackable_attributes(auth_objects = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_objects = nil)
    []
  end

  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  scope :recent, -> { order(created_at: :desc)}

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end
end


#bundle exec rspec -f d spec/system/tasks_spec.rb