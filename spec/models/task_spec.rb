require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'すべての属性が有効であること' do
      task = FactoryBot.build(:task)
      task.valid?
      expect(task.errors).to be_empty
    end

    it 'タイトルが未入力の場合に無効になること' do
      without_task_title = FactoryBot.build(:task, title: nil)
      without_task_title.invalid?
      expect(without_task_title.errors[:title]).to include("can't be blank")
    end

    it 'ステータス未選択の場合に無効になること' do
      without_task_status = FactoryBot.build(:task, status: nil)
      without_task_status.invalid?
      expect(without_task_status.errors[:status]).to include("can't be blank")
    end

    it 'タイトルが重複している場合に無効になること' do
      task = FactoryBot.create(:task)
      duplicate_task_title = FactoryBot.build(:task, title: task.title)
      duplicate_task_title.invalid?
      expect(duplicate_task_title.errors[:title]).to include("has already been taken")
    end

    it '別のタイトルだと有効になること' do
      task = FactoryBot.create(:task)
      another_task_title = FactoryBot.build(:task, title: 'test_title')
      another_task_title.valid?
      expect(another_task_title.errors).to be_empty
    end
  end
end
