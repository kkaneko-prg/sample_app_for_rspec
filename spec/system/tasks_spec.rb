require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user){ create(:user) }
  let(:task){ create(:task) }
  
  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの詳細ページにアクセス' do
        it 'タスクの詳細情報が表示される' do
          visit task_path(task)
          expect(page).to have_content task.title
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タスクの一覧ページにアクセス' do
        it 'すべてのユーザーのタスク情報が表示される' do
          tasks = create_list(:task, 5)
          visit tasks_path
          expect(page).to have_content tasks[0].title
          expect(page).to have_content tasks[1].title
          expect(current_path).to eq tasks_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    describe 'タスク新規登録' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Content', with: 'test_content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021-04-21-23:30'
          click_button 'Create Task'
          expect(page).to have_content 'Title: test_title'
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'test_content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021-04-21-23:30'
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: task.title
          fill_in 'Content', with: 'test_content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: '2021-04-21-23:30'
          click_button 'Create Task'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq tasks_path          
        end
      end
    end

    describe 'タスク編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'change_title'
          select :done, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Title: change_title'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          select :done, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: other_task.title
          select :done, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq task_path(task)          
        end
      end
    end

    describe 'タスク削除' do
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除が成功する' do
        visit tasks_path
        click_on 'Destroy'
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
