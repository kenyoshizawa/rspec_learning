NUM_DUMMY_USERS = 2
DUMMY_PASSWORD = "password"
User.destroy_all if Rails.env.development?

puts "#{NUM_DUMMY_USERS} 件のUserオブジェクトを作成します"
created_count = 0

NUM_DUMMY_USERS.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.unique.email

  user_attributes = {
    first_name: first_name,
    last_name: last_name,
    password: DUMMY_PASSWORD,
    password_confirmation: DUMMY_PASSWORD
  }

  user = User.find_or_initialize_by(email: email)

  if user.new_record?
    user.assign_attributes(user_attributes)
    begin
      user.save!
      created_count += 1
      print '.'
    rescue ActiveRecord::RecordInvalid => e
      puts "--------------------------------------------------"
      puts "エラークラス：#{e.class}"
      puts "エラーメッセージ：#{e.message}"
      puts "エラー詳細："
      puts e.record.errors.full_messages
      puts "--------------------------------------------------"
      # 一件でもレコードの保存が失敗した場合、処理を中断する
      raise "[ERROR] Userオブジェクト作成中にバリデーションエラーが発生したため、処理を中止しました"
    end
  else
    raise "[ERROR] 既存のユーザーが見つかりました"
  end
end

puts "\nUserオブジェクトの作成が完了しました"
