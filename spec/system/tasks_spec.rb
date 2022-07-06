require 'rails_helper'

describe 'タスク管理機能', type: :system do
  #letでユーザを作る(遅延評価)
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザB', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

  before do
    visit login_path
    fill_in 'メールアドレス',	with: login_user.email
    fill_in 'パスワード',	with: login_user.password
    click_button 'ログインする'
  end

  #itの共通化
  shared_examples_for 'ユーザAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能'do
    context 'ユーザAがログインしているとき' do
      let(:login_user) { user_a } #自作
      it_behaves_like 'ユーザAが作成したタスクが表示される'
    end

    context 'ユーザBがログインしているとき' do
      let(:login_user) { user_b }
      it 'ユーザAのタスクは表示されない' do
        expect(page).not_to have_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザAがログインしているとき' do
      let(:login_user) { user_a }
      before do
        visit task_path(task_a)
      end
      it_behaves_like 'ユーザAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    let(:task_name) { '新規作成のテストを書く' }

    before do
      visit confirm_new_task_path
      fill_in '名称', with: task_name #名称を格納する変数
      click_button '登録'
    end

    context '新規作成画面で名称を入力したとき' do
      it '正常に動作する' do
        expect(page).to have_selector '.alert-success', text: 'タスク「新規作成のテストを書く」を登録しました。'
      end
    end
    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }
      it 'エラーとなる' do
        expect(page).to have_content '名称を入力してください'
      end
    end
  end
end