NUM_DUMMY_PROJECTS_PER_USER = 3
Project.destroy_all if Rails.env.development?

users = User.all

if users.empty?
  puts '[ERROR] Projectを作成するためのUserデータが存在しないため、処理を中断しました'
  puts '[ERROR] 先に db/seeds/users.rb を実行してください'
  return
end

puts "各Userに対して #{NUM_DUMMY_PROJECTS_PER_USER} 件のProjectオブジェクトを作成します"
created_count = 0

users.each do |user|
  NUM_DUMMY_PROJECTS_PER_USER.times do
    project_name = Faker::App.unique.name
    description = Faker::Lorem.paragraph(sentence_count: 3)
    due_on = Faker::Date.between(from: 1.week.from_now, to: 3.months.from_now)

    project_attributes = {
      description: description,
      due_on: due_on
    }

    project = user.projects.find_or_initialize_by(name: project_name)

    if project.new_record?
      project.assign_attributes(project_attributes)
      begin
        project.save!
        created_count += 1
        print '.'
      rescue ActiveRecord::RecordInvalid => e
        puts "--------------------------------------------------"
        puts "エラークラス：#{e.class}"
        puts "エラーメッセージ：#{e.message}"
        puts "エラー詳細：#{e.record.errors.full_messages}"
        puts "--------------------------------------------------"
        # 一件でもレコードの保存が失敗した場合、処理を中断する
        raise "[ERROR] Projectオブジェクト作成中にバリデーションエラーが発生したため、処理を中止しました"
      end
    else
      raise "[ERROR] 既存のプロジェクトが見つかりました"
    end
  end
end

puts "\nProjectオブジェクトの作成が完了しました"
