NUM_DUMMY_NOTES_PER_PROJECT = 2
Note.destroy_all if Rails.env.development?

projects = Project.includes(:user).all

if projects.empty?
  puts '[ERROR] Noteを作成するためのProjectデータが存在しないため、処理を中断しました'
  puts '[ERROR] 先に db/seeds/projects.rb を実行してください'
  return
end

puts "各Projectに対して #{NUM_DUMMY_NOTES_PER_PROJECT} 件のNoteオブジェクトを作成します"
created_count = 0

projects.each do |project|
  user = project.user
  unless user
    puts "[WARNING] Project ID: #{project.id} に紐づくUserが見つからないため、このプロジェクトのノート作成をスキップします"
    next
  end

  NUM_DUMMY_NOTES_PER_PROJECT.times do
    begin
      user.notes.create!(
        message: Faker::Lorem.sentence(word_count: 10, supplemental: true, random_words_to_add: 4),
        project_id: project.id
      )
      created_count += 1
      print '.'
    rescue ActiveRecord::RecordInvalid => e
      puts "--------------------------------------------------"
      puts "エラークラス：#{e.class}"
      puts "エラーメッセージ：#{e.message}"
      puts "エラー詳細：#{e.record.errors.full_messages}"
      puts "--------------------------------------------------"
      # 一件でもレコードの保存が失敗した場合、処理を中断する
      raise "[ERROR] Noteオブジェクト作成中にバリデーションエラーが発生したため、処理を中止しました"
    end
  end
end

puts "\nNoteオブジェクトの作成が完了しました"
